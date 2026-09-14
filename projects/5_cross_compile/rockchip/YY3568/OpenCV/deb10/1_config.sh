#!/usr/bin/env bash
# ------------------------------------------------------------
# 1_config.sh - Configure Headless OpenCV for RK3568 (EGLFS)
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${OPENCV_SRC_DIR}" ]]; then
	err "OpenCV source directory not found at: ${OPENCV_SRC_DIR}"
	exit 1
fi

if [[ ! -f "${OPENCV_TOOLCHAIN_FILE}" ]]; then
	err "CMake toolchain file not found at: ${OPENCV_TOOLCHAIN_FILE}"
	exit 1
fi

msg "Configuring OpenCV for RK3568 (Headless / Direct V4L2 / EGLFS)..."

mkdir -p "${OPENCV_BUILD_DIR}"
pushd "${OPENCV_BUILD_DIR}" >/dev/null

cmake "${OPENCV_SRC_DIR}" \
	-GNinja \
	-DCMAKE_TOOLCHAIN_FILE="${OPENCV_TOOLCHAIN_FILE}" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX="${OPENCV_STAGING_DIR}" \
	-DOPENCV_SKIP_PKGCONFIG_GENERATION=OFF \
	-DOPENCV_GENERATE_PKGCONFIG=ON \
	-DOPENCV_EXTRA_MODULES_PATH="${OPENCV_CONTRIB_DIR}" \
	-DWITH_GTK=OFF \
	-DWITH_GTK_2_X=OFF \
	-DWITH_X11=OFF \
	-DWITH_WAYLAND=OFF \
	-DWITH_QT=OFF \
	-DBUILD_opencv_highgui=OFF \
	-DWITH_GSTREAMER=OFF \
	-DWITH_V4L=ON \
	-DWITH_LIBV4L=ON \
	-DENABLE_NEON=ON \
	-DCPU_BASELINE="NEON" \
	-DBUILD_opencv_core=ON \
	-DBUILD_opencv_imgproc=ON \
	-DBUILD_opencv_videoio=ON \
	-DBUILD_opencv_imgcodecs=ON \
	-DBUILD_TESTS=OFF \
	-DBUILD_PERF_TESTS=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_DOCS=OFF \
	-DBUILD_opencv_apps=OFF \
	-DBUILD_opencv_python2=OFF \
	-DBUILD_opencv_python3=OFF \
	-DBUILD_opencv_java=OFF \
	-DBUILD_opencv_gapi=OFF \
	-DBUILD_opencv_dnn=OFF \
	-DBUILD_opencv_ml=OFF \
	-DBUILD_opencv_flann=OFF \
	-DBUILD_opencv_features2d=OFF \
	-DBUILD_opencv_calib3d=OFF

popd >/dev/null

msg "Configuration complete. Next step: ./2_build.sh"
