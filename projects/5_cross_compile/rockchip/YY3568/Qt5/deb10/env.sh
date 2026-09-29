#!/usr/bin/env bash
# ------------------------------------------------------------
# env.sh - shared configuration for RK3568 Qt 5.15.2 cross-build
# ------------------------------------------------------------

export ARCH="arm64"
export CROSS_COMPILE="/usr/bin/aarch64-linux-gnu-"

# Target Sysroot
SYSROOT_DIR="/home/danial/rk-deb10-sysroot"

# Qt Sources
QT_VERSION="5.15.2"
QT_SRC_DIR="/home/danial/qt-everywhere-src-${QT_VERSION}"

# Build, Staging, and Target Installation Directories
BUILD_DIR="$(pwd)/build-qt5-rk-deb10"
STAGING_DIR="/home/danial/qt5-rk-deb10"      # Target libraries/headers for app building
HOST_PREFIX="/home/danial/qt5-rk-host-tools" # Host qmake, moc, rcc
INSTALL_PREFIX="/usr/local/qt5rk"            # Path ON THE BOARD

# Sysroot Pkg-Config
export PKG_CONFIG_DIR=""
export PKG_CONFIG_LIBDIR="${SYSROOT_DIR}/usr/lib/aarch64-linux-gnu/pkgconfig:${SYSROOT_DIR}/usr/share/pkgconfig:${SYSROOT_DIR}/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT_DIR}"

msg() {
	echo -e "\033[1;34m[qt5-rk3568]\033[0m $*"
}
