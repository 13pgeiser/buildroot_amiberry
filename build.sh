#!/bin/bash
set -ex
EXT=xz
BUILDROOT_VERSION=2025.08.1
if [ -z "$1" ]; then
	steps="buildroot apt defconfig sdk build release"
else
	steps="$@"
fi
for step in $steps; do
	case $step in
		"buildroot")
			if [ ! -e "buildroot-${BUILDROOT_VERSION}.tar.${EXT}" ]; then
				wget "https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.${EXT}"
			fi
			if [ ! -e "buildroot-${BUILDROOT_VERSION}" ]; then
				if [ "$EXT" == "xz" ]; then
					tar xvJf "buildroot-${BUILDROOT_VERSION}.tar.${EXT}"
				fi
				if [ "$EXT" == "bz2" ]; then
					tar xvjf "buildroot-${BUILDROOT_VERSION}.tar.${EXT}"
				fi
			fi
			;;
		"apt")
			sudo apt install -y sed make binutils gcc g++ bash build-essential \
				patch gzip bzip2 perl tar cpio python3 unzip rsync wget \
				libncurses-dev bc findutils zstd file
			;;
		"defconfig")
			(
			cd "buildroot-${BUILDROOT_VERSION}" || exit 1
			make BR2_EXTERNAL=../pag raspberrypi4_64_defconfig
			)
			;;
		"sdk")
			(
			cd "buildroot-${BUILDROOT_VERSION}" || exit 1
			make BR2_EXTERNAL=../pag prepare-sdk
			)
			;;
		"build")
			(
			cd "buildroot-${BUILDROOT_VERSION}" || exit 1
			make BR2_EXTERNAL=../pag all 2>&1 | tee make.log
			)
			;;
		"release")
			mkdir -p release
			cp "buildroot-${BUILDROOT_VERSION}/output/images/sdcard.img" release/
			zstd --rm release/sdcard.img
			;;
		*)
			echo "Unsupported step: $step"
			exit 1
			;;

	esac
done
