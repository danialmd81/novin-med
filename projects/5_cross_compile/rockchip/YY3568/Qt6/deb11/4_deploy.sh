#!/usr/bin/env bash
# ------------------------------------------------------------
# deploy.sh - rsync the staged Qt6 install to the RK3568 board and
# set up runtime env vars there (run after install.sh)
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${STAGING_DIR}" ]]; then
	msg "${STAGING_DIR} not found - run ./config.sh, ./build.sh, ./install.sh first."
	exit 1
fi

msg "Deploying ${STAGING_DIR} to ${RK_HOST}:${INSTALL_PREFIX}"

ssh "${RK_HOST}" "mkdir -p '${INSTALL_PREFIX}'"

rsync -avz --delete \
	"${STAGING_DIR}/" \
	"${RK_HOST}:${INSTALL_PREFIX}/"

msg "Writing environment profile to the device"
ssh "${RK_HOST}" "cat > /etc/profile.d/qt6rk.sh" <<-EOF
	export QT_QPA_PLATFORM=eglfs
	export QT_QPA_PLATFORM_PLUGIN_PATH=${INSTALL_PREFIX}/plugins/platforms
	export LD_LIBRARY_PATH=${INSTALL_PREFIX}/lib:\${LD_LIBRARY_PATH}
EOF
ssh "${RK_HOST}" "chmod +x /etc/profile.d/qt6rk.sh"

msg "Deployed. New SSH sessions on the device will pick up the env vars."
msg "For the current session run: source /etc/profile.d/qt6rk.sh"
msg "Qt6 cross-compilation and deployment for RK3568 completed successfully."
