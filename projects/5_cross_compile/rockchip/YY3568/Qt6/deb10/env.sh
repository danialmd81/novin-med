#!/usr/bin/env bash
# ------------------------------------------------------------
# env.sh - shared configuration for the RK3568 Qt6 cross-build
# ------------------------------------------------------------

# Generic aarch64 device mkspec
DEVICE_MKSPEC="linux-aarch64-gnu-g++"

# Cross compiler prefix matching your sysroot triplet
CROSS_COMPILE="/usr/bin/aarch64-linux-gnu-"

# EGLFS backend for RK3568 Mali GPU
EGLFS_DEVICE_INTEGRATION="eglfs_kms"

# Sysroot directory
SYSROOT_DIR="/home/danial/rk-deb10-sysroot"

# Qt Version & Paths
QT_VERSION="6.2.4"
QT_SRC_DIR="/home/danial/qt-everywhere-src-${QT_VERSION}"
QT_HOST_PATH="/home/danial/Qt/${QT_VERSION}/gcc_64"

# Build / staging / final install directories
BUILD_DIR="$(pwd)/build-qt6-rk-deb10"
STAGING_DIR="/home/danial/qt6-rk-deb10"
INSTALL_PREFIX="/usr/local/qt6rk"
TOOLCHAIN_FILE="$(pwd)/toolchain.cmake"

###############################################
# Shared Helpers
###############################################
msg() {
	echo -e "\033[1;34m[qt6-rk3568]\033[0m $*"
}
