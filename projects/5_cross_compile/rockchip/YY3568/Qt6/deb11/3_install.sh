#!/usr/bin/env bash
# ------------------------------------------------------------
# install.sh - install Qt6 to the local staging dir (run after build.sh)
# No sudo needed: STAGING_DIR is just a local folder you build apps
# against and later rsync to the board - INSTALL_PREFIX only needs to
# exist ON THE DEVICE (see deploy.sh), not on this host.
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${BUILD_DIR}" ]]; then
	msg "${BUILD_DIR} not found - run ./config.sh and ./build.sh first."
	exit 1
fi

msg "Installing Qt to staging dir ${STAGING_DIR}"
pushd "${BUILD_DIR}" >/dev/null
cmake --install .
popd >/dev/null

msg "Install done."
msg "For CMake projects: ${STAGING_DIR}/bin/qt-cmake"
msg "For legacy .pro projects: use your HOST qmake with -spec pointing at"
msg "  ${STAGING_DIR}/mkspecs/devices/${DEVICE_MKSPEC}"
msg "Next: ./deploy.sh"
