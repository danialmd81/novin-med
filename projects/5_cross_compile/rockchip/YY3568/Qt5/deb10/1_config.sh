#!/usr/bin/env bash
# ------------------------------------------------------------
# 1_config.sh - configure Qt 5.15.2 for RK3568 cross-compilation
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${QT_SRC_DIR}" ]]; then
	echo "Error: Qt source directory not found at ${QT_SRC_DIR}"
	exit 1
fi

msg "Configuring Qt 5.15.2 for RK3568..."
mkdir -p "${BUILD_DIR}" "${STAGING_DIR}" "${HOST_PREFIX}"
pushd "${BUILD_DIR}" >/dev/null

"${QT_SRC_DIR}/configure" \
	-release \
	-opensource -confirm-license \
	-sysroot "${SYSROOT_DIR}" \
	-prefix "${INSTALL_PREFIX}" \
	-extprefix "${STAGING_DIR}" \
	-hostprefix "${HOST_PREFIX}" \
	-xplatform linux-aarch64-gnu-g++ \
	-device-option CROSS_COMPILE="${CROSS_COMPILE}" \
	-opengl es2 \
	-eglfs \
	-kms \
	-gbm \
	-pkg-config \
	-make libs \
	-make tools \
	-nomake examples \
	-nomake tests \
	-skip qtwebengine \
	-skip qtscript \
	-skip qtdatavis3d \
	-skip qtwayland \
	-no-use-gold-linker

popd >/dev/null

msg "Configure complete. Verifying EGLFS and Multimedia summary:"
grep -A15 'EGLFS' "${BUILD_DIR}/config.summary" || true
grep -A10 'Qt Multimedia' "${BUILD_DIR}/config.summary" || true
