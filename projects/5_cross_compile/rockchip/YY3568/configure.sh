#!/bin/bash

# Define paths for cleaner organization
SYSROOT="/home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/YY3568-Debian10-sysroot"
TOOLCHAIN="/home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/YY3568-Debian10/prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-"
CONFIGURE="/home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/qt-everywhere-src-5.15.19/configure"
HOSTPREFIX="/home/danial/Code/novin-med/projects/5_cross_compile/rockchip/YY3568/qt5-cross-compile-qmake"
PREFIX="/usr/local/qt5"

# CRITICAL: Force pkg-config to use sysroot paths (i doubt that)
export PKG_CONFIG_DIR=""
export PKG_CONFIG_LIBDIR="${SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${SYSROOT}/usr/share/pkgconfig:${SYSROOT}/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT}"

rm -rf qt5-build
mkdir -p qt5-build
cd qt5-build

"$CONFIGURE" \
	-release \
	-opengl es2 \
	-sysroot "$SYSROOT" \
	-prefix "$PREFIX" \
	-hostprefix "$HOSTPREFIX" \
	-device linux-rkchip-yy3568-g++ \
	-device-option CROSS_COMPILE="$TOOLCHAIN" \
	-opensource -confirm-license \
	-make tools \
	-skip qtscript -skip qtdatavis3d -skip qtwebengine \
	-nomake examples -nomake tests \
	-pkg-config \
	-no-use-gold-linker
