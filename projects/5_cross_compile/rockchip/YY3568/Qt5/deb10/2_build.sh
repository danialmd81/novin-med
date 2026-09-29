#!/usr/bin/env bash
# ------------------------------------------------------------
# build.sh - compile Qt5 (run after config.sh succeeds)
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${BUILD_DIR}" ]]; then
	msg "${BUILD_DIR} not found - run ./1_config.sh first."
	exit 1
fi

msg "Building Qt 5 (using $(nproc) jobs)..."
pushd "${BUILD_DIR}" >/dev/null
make -j$(nproc)
popd >/dev/null

msg "Build done. Next: ./3_install.sh"
