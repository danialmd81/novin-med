#!/usr/bin/env bash
# ------------------------------------------------------------
# env.sh - Shared environment for RK3568 OpenCV cross-build
# ------------------------------------------------------------

# Cross compiler configuration
export CROSS_COMPILE="/usr/bin/aarch64-linux-gnu-"

# Sysroot directory
export SYSROOT_DIR="/home/danial/rk-deb11-sysroot"

# OpenCV Source & Contrib Locations
export OPENCV_SRC_DIR="/home/danial/Code/novin-med/projects/laserscanner/3rdparty/opencv"
export OPENCV_CONTRIB_DIR="/home/danial/Code/novin-med/projects/laserscanner/3rdparty/opencv_contrib/modules"

# Build & Installation Directories
export OPENCV_BUILD_DIR="$(pwd)/build-opencv-rk-deb11"
export OPENCV_STAGING_DIR="/home/danial/opencv-rk-deb11"
export OPENCV_TOOLCHAIN_FILE="$(pwd)/opencv-rk-toolchain.cmake"

# Logging Helpers
msg() {
	echo -e "\033[1;34m[opencv-rk3568]\033[0m $*"
}

err() {
	echo -e "\033[1;31m[Error]\033[0m $*" >&2
}
