#!/usr/bin/env bash
# ------------------------------------------------------------
# 3_install.sh - Install OpenCV to the local staging directory
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${OPENCV_BUILD_DIR}" ]]; then
	err "Build directory ${OPENCV_BUILD_DIR} not found. Run ./1_config.sh and ./2_build.sh first."
	exit 1
fi

msg "Installing OpenCV to staging directory: ${OPENCV_STAGING_DIR}"
pushd "${OPENCV_BUILD_DIR}" >/dev/null

cmake --install .

popd >/dev/null

msg "Install complete!"
msg "Staging directory: ${OPENCV_STAGING_DIR}"
msg "To cross-compile laserscanner, configure with:"
msg "  -DOpenCV_DIR=${OPENCV_STAGING_DIR}/lib/cmake/opencv4"
