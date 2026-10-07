#!/usr/bin/env bash
# ------------------------------------------------------------
# env.sh - shared configuration for RPi4 Raspbian Buster armhf Qt 5.15.2
# ------------------------------------------------------------

export ARCH="arm"
export CROSS_COMPILE="/usr/bin/arm-linux-gnueabihf-"

# Target Sysroot (sync your RPi root filesystem here, or use / if using container's multiarch libs)
SYSROOT_DIR="/home/danial/rpi4-deb10-sysroot"

# Qt Sources
QT_VERSION="5.15.2"
QT_SRC_DIR="/home/danial/qt-everywhere-src-${QT_VERSION}"

# Build, Staging, and Target Installation Directories
BUILD_DIR="$(pwd)/build-qt5-rpi4-deb10"
STAGING_DIR="/home/danial/qt5-rpi4-deb10"      # Target libraries/headers for app building
HOST_PREFIX="/home/danial/qt5-rpi4-host-tools" # Host qmake, moc, rcc
INSTALL_PREFIX="/usr/local/qt5rpi4"           # Path ON THE PI

# Sysroot Pkg-Config
export PKG_CONFIG_DIR=""
export PKG_CONFIG_LIBDIR="${SYSROOT_DIR}/usr/lib/arm-linux-gnueabihf/pkgconfig:${SYSROOT_DIR}/usr/share/pkgconfig:${SYSROOT_DIR}/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT_DIR}"

msg() {
	echo -e "\033[1;32m[qt5-rpi4-armhf]\033[0m $*"
}