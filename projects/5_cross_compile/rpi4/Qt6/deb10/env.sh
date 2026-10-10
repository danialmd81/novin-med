#!/usr/bin/env bash
# ------------------------------------------------------------
# env.sh - shared configuration for RPi4 32-bit (armhf) Qt6 cross-build
# ------------------------------------------------------------

# Target 32-bit ARM mkspec
DEVICE_MKSPEC="linux-arm-gnueabi-g++"

# Cross-compiler prefix matching the container and sysroot triplet
CROSS_COMPILE="/usr/bin/arm-linux-gnueabihf-"

# EGLFS KMS/DRM backend for Raspberry Pi 4 VC4/V3D driver
EGLFS_DEVICE_INTEGRATION="eglfs_kms"

# Sysroot directory containing the RPi4 root filesystem
SYSROOT_DIR="/home/danial/rpi4-deb10-sysroot"

# Qt Version & Paths
QT_VERSION="6.2.4"
QT_SRC_DIR="/home/danial/qt-everywhere-src-${QT_VERSION}"
QT_HOST_PATH="/home/danial/Qt/${QT_VERSION}/gcc_64"

# Build / staging / final install directories
BUILD_DIR="$(pwd)/build-qt6-rpi4-deb10"
STAGING_DIR="/home/danial/qt6-rpi4-deb10"
INSTALL_PREFIX="/usr/local/qt6rpi4"
TOOLCHAIN_FILE="$(pwd)/toolchain.cmake"

###############################################
# Shared Helpers
###############################################
msg() {
	echo -e "\033[1;34m[qt6-rpi4]\033[0m $*"
}