#!/usr/bin/env bash
# ------------------------------------------------------------
# build.sh - compile Qt6 (run after config.sh succeeds)
# ------------------------------------------------------------
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/env.sh"

if [[ ! -d "${BUILD_DIR}" ]]; then
	msg "${BUILD_DIR} not found - run ./config.sh first."
	exit 1
fi

ensure_toolchain

msg "Building Qt (this may take a while)"
pushd "${BUILD_DIR}" >/dev/null
cmake --build . --parallel
popd >/dev/null

msg "Build done. Next: ./install.sh"
