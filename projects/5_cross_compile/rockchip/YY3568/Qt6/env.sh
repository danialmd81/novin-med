#!/usr/bin/env bash
# ------------------------------------------------------------
# env.sh - shared configuration for the RK3568 Qt6 cross-build
# ------------------------------------------------------------

# Generic aarch64 device mkspec
DEVICE_MKSPEC="linux-aarch64-gnu-g++"

# Cross compiler prefix matching your sysroot triplet
CROSS_COMPILE="/usr/bin/aarch64-linux-gnu-"

# EGLFS backend for RK3568 Mali GPU
# Run `ls /usr/lib/aarch64-linux-gnu/libmali*` in sysroot to check.
# If libmali-bifrost-g52-m400-gbm.so exists -> use eglfs_gbm
EGLFS_DEVICE_INTEGRATION="eglfs_gbm"
# EGLFS_DEVICE_INTEGRATION="eglfs_mali"

# Remote board (SSH reachable)
RK_HOST="root@rk3568device"

# Sysroot directory
SYSROOT_DIR="${HOME}/rk-deb10-sysroot"

# Qt Version & Paths
QT_VERSION="6.9.3"
QT_SRC_DIR="${HOME}/qt-everywhere-src-${QT_VERSION}"
QT_HOST_PATH="${HOME}/Qt/${QT_VERSION}/gcc_64"

# Build / staging / final install directories
BUILD_DIR="$(pwd)/build-rk3568"
STAGING_DIR="$(pwd)/qt6-rk3568"
INSTALL_PREFIX="/usr/local/qt6rk"
TOOLCHAIN_FILE="$(pwd)/toolchain.cmake"

###############################################
# Shared Helpers & Environment Fixes
###############################################
msg() {
	echo -e "\033[1;34m[qt6-rk3568]\033[0m $*"
}

# Redirect pkg-config strictly to target sysroot
export PKG_CONFIG_DIR=""
export PKG_CONFIG_LIBDIR="${SYSROOT_DIR}/usr/lib/aarch64-linux-gnu/pkgconfig:${SYSROOT_DIR}/usr/share/pkgconfig:${SYSROOT_DIR}/usr/lib/pkgconfig"
export PKG_CONFIG_SYSROOT_DIR="${SYSROOT_DIR}"

ensure_toolchain() {
	if [[ ! -x "${CROSS_COMPILE}gcc" ]]; then
		msg "Toolchain not found at ${CROSS_COMPILE}gcc."
		msg "Install with: sudo apt install g++-aarch64-linux-gnu"
		exit 1
	fi
	export PATH="$(dirname "${CROSS_COMPILE}"):${PATH}"
	msg "Toolchain OK ($(${CROSS_COMPILE}g++ --version | head -1))"
}

check_qt_source() {
	if [[ ! -d "${QT_SRC_DIR}" ]]; then
		msg "Missing source folder: ${QT_SRC_DIR}"
		exit 1
	fi
	msg "Qt source present: ${QT_SRC_DIR}"
}

check_sysroot() {
	if [[ ! -d "${SYSROOT_DIR}" ]]; then
		msg "Sysroot not found at ${SYSROOT_DIR}."
		exit 1
	fi
	msg "Using sysroot ${SYSROOT_DIR}"
}
