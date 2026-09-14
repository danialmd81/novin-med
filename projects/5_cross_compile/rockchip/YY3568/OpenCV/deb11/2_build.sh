#!/usr/bin/env bash
# ------------------------------------------------------------
# 2_build.sh - Compile OpenCV using Ninja
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${OPENCV_BUILD_DIR}" ]]; then
	err "Build directory ${OPENCV_BUILD_DIR} not found. Run ./1_config.sh first."
	exit 1
fi

msg "Building OpenCV with Ninja..."
pushd "${OPENCV_BUILD_DIR}" >/dev/null

ninja -j$(nproc)

popd >/dev/null

msg "Build complete. Next step: ./3_install.sh"
