#!/usr/bin/env bash
# ------------------------------------------------------------
# install.sh - install Qt5 to the local staging dir (run after build.sh)
# No sudo needed: STAGING_DIR is just a local folder you build apps
# against and later rsync to the board - INSTALL_PREFIX only needs to
# exist ON THE DEVICE (see deploy.sh), not on this host.
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${BUILD_DIR}" ]]; then
	msg "${BUILD_DIR} not found - run ./1_config.sh and ./2_build.sh first."
	exit 1
fi

msg "Installing Qt 5 to ${STAGING_DIR} and host tools to ${HOST_PREFIX}..."
pushd "${BUILD_DIR}" >/dev/null
make install
popd >/dev/null

msg "Install complete."
msg "Host qmake location: ${HOST_PREFIX}/bin/qmake"
msg "Target staging directory: ${STAGING_DIR}"
