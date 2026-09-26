# AGENTS.md

Buildroot image for Amiberry on Raspberry Pi 4 / Pi 400. This repo is only the wrapper; the actual buildroot source is downloaded and the custom content lives in `pag/`.

## Layout

- `build.sh` — the only build entrypoint. Steps: `buildroot apt defconfig sdk build release` (default runs all in that order).
- `pag/` — buildroot external tree (`BR2_EXTERNAL`). Everything custom is here:
  - `pag/package/{amiberry,libenet,portmidi}/` — package `.mk` + `Config.in` (wired in via `pag/external.mk` / `pag/Config.in`).
  - `pag/configs/raspberrypi4_64_defconfig` — the main config, loaded as a `raspberrypi4_64_defconfig` make target.
  - `pag/board/amiga/` — board files referenced by the defconfig (`config.txt`, `users.txt`, `rootfs_overlay/`).
- `buildroot-<ver>/` — downloaded by `./build.sh buildroot`, gitignored, not part of the repo.
- `release/` — output dir, gitignored. Final artifact: `release/sdcard.img.zst`.

## Commands

- Full build: `./build.sh` (order matters: defconfig before build; `sdk` step = `make prepare-sdk`).
- Single step: `./build.sh <step>` (e.g. `./build.sh build` after defconfig already ran).
- Nuke state: `./clean.sh` (removes `buildroot-*`, `ccache-buildroot`, `release`).

## Gotchas

- No lint/typecheck/test — verification is a successful `./build.sh build` (log in `make.log` inside `buildroot-*/`).
- Buildroot version is pinned in `build.sh` (`BUILDROOT_VERSION`); amiberry version is pinned in `pag/package/amiberry/amiberry.mk` (`AMIBERRY_VERSION`, from amiberry-lite release tags). Bump both there.
- All buildroot invocations require `BR2_EXTERNAL=../pag` — it's baked into `build.sh`; don't run `make` in `buildroot-*/` without it or the `pag` config/packages won't load.
- Kernel is pinned to a raspberrypi/linux commit (`ac69f097...`) in the defconfig, `bcm2711` defconfig; don't swap in generic configs.
- The `apt` step needs sudo; on a machine with build deps already installed you can skip it.
- `defconfig` must be re-run (followed by `sdk` + `build`) whenever `pag/configs/raspberrypi4_64_defconfig` or `pag/Config.in` changes; a `.mk`-only package change only needs `build`.
- `amiberry` is the only `INSTALL_TARGET` custom package; libenet (staging-only static lib) and portmidi are its deps — see `AMIBERRY_DEPENDENCIES` in the `.mk` if adding one.

## CI

- Tag push triggers `.github/workflows/publish.yml`, which runs the same `build.sh` steps and publishes `release/*` to a GitHub release. Reproduce locally with `./build.sh` before cutting a tag.
- `.buildbot` mirrors the same flow (clean → build → upload release → clean).
