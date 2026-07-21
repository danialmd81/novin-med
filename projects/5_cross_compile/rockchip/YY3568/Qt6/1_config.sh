#!/usr/bin/env bash
# ------------------------------------------------------------
# config.sh - configure Qt6 for RK3568 cross-compilation
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

ensure_toolchain
check_qt_source
check_sysroot

msg "Configuring Qt for RK3568 cross-compilation..."
mkdir -p "${BUILD_DIR}" "${STAGING_DIR}"
pushd "${BUILD_DIR}" >/dev/null

"${QT_SRC_DIR}/configure" \
	-release \
	-opengl es2 \
	-egl \
	-platform "${DEVICE_MKSPEC}" \
	-device-option CROSS_COMPILE="${CROSS_COMPILE}" \
	-device-option EGLFS_DEVICE_INTEGRATION="${EGLFS_DEVICE_INTEGRATION}" \
	-qt-host-path "${QT_HOST_PATH}" \
	-extprefix "${STAGING_DIR}" \
	-prefix "${INSTALL_PREFIX}" \
	-opensource -confirm-license \
	-skip qtscript -skip qtwayland -skip qtdatavis3d -skip qtwebengine -skip qtgrpc -skip qtopcua \
	-nomake examples -nomake tests \
	-pkg-config \
	-no-use-gold-linker \
	-- -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}"

popd >/dev/null

msg "Configure complete. Verify EGLFS and GBM capabilities in summary:"
msg "  grep -A15 'EGLFS' ${BUILD_DIR}/config.summary"
