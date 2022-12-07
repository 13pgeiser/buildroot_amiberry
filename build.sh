#!/bin/bash
set -ex
EXT=xz
BUILDROOT_VERSION=2022.02.1
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
sudo apt install -y sed make binutils gcc g++ bash patch gzip bzip2 perl tar cpio python unzip rsync wget libncurses-dev
(
	cd "buildroot-${BUILDROOT_VERSION}" || exit 1
	make BR2_EXTERNAL=../pag raspberrypi4_64_defconfig
	make BR2_EXTERNAL=../pag all 2>&1 | tee make.log
)
mkdir -p release
cp "buildroot-${BUILDROOT_VERSION}/output/images/sdcard.img" release/
