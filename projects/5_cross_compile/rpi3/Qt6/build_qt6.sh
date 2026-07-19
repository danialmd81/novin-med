#!/usr/bin/env bash

# ------------------------------------------------------------
# Qt6 Cross‑Compilation Script for Raspberry Pi 3 (EGLFS)
# ------------------------------------------------------------
# This script automates the steps described in the README.md file.
# It assumes you have a working SSH connection to the target device
# (default user: root, host: rpi3device) and that the Linaro toolchain
# is available on the host machine.
#
# Adjust the variables below to match your environment before running.
# ------------------------------------------------------------

set -e

###############################################
# Configuration – edit these as needed
###############################################

# Path to the Linaro toolchain (must contain bin/arm-linux-gnueabihf-*)
TOOLCHAIN_DIR="${HOME}/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf"

# Remote Raspberry‑Pi device (SSH reachable)
RPI_HOST="root@rpi3device"

# Absolute path where the sysroot will be created on the host
SYSROOT_DIR="$(pwd)/sysroot"

# Qt source archive (you can also use a git clone)
QT_VERSION="6.11.1"
QT_TAR="qt-everywhere-src-${QT_VERSION}.tar.xz"
QT_SRC_DIR="qt-everywhere-src-${QT_VERSION}"

# Build and install directories (absolute paths)
BUILD_DIR="$(pwd)/qtpi-build"
INSTALL_PREFIX="/usr/local/qt6pi"
HOST_PREFIX="$(pwd)/qt-host"

###############################################
# Helper functions
###############################################
msg() {
	echo -e "\033[1;34m[qt6‑cross]\033[0m $*"
}

ensure_toolchain() {
	if [[ ! -x "${TOOLCHAIN_DIR}/bin/arm-linux-gnueabihf-gcc" ]]; then
		msg "Toolchain not found at ${TOOLCHAIN_DIR}. Please download and extract it first."
		exit 1
	fi
	export PATH="${TOOLCHAIN_DIR}/bin:${PATH}"
	msg "Toolchain added to PATH"
}

fetch_qt_source() {
	if [[ -d "${QT_SRC_DIR}" ]]; then
		msg "Qt source already present: ${QT_SRC_DIR}"
		return
	fi
	msg "add Qt ${QT_VERSION} source tar"
	tar -xf "${QT_TAR}"
	msg "Qt source extracted to ${QT_SRC_DIR}"
}

create_sysroot() {
	msg "Creating sysroot directory ${SYSROOT_DIR}"
	mkdir -p "${SYSROOT_DIR}" "${SYSROOT_DIR}/usr" "${SYSROOT_DIR}/opt"
	msg "Syncing libraries and headers from the Raspberry‑Pi"
	rsync -avz "${RPI_HOST}:/lib" "${SYSROOT_DIR}" || true
	rsync -avz "${RPI_HOST}:/usr/include" "${SYSROOT_DIR}/usr" || true
	rsync -avz "${RPI_HOST}:/usr/lib" "${SYSROOT_DIR}/usr" || true
	rsync -avz "${RPI_HOST}:/opt/vc" "${SYSROOT_DIR}/opt" || true
	msg "Fixing relative symlinks in the sysroot"
	if [[ ! -f "sysroot-relativelinks.py" ]]; then
		curl -L "https://raw.githubusercontent.com/Kukkimonsuta/buildqt/master/scripts/utils/sysroot-relativelinks.py" -o sysroot-relativelinks.py
		chmod +x sysroot-relativelinks.py
	fi
	./sysroot-relativelinks.py "${SYSROOT_DIR}"
}

configure_qt() {
	msg "Configuring Qt for cross‑compilation"
	mkdir -p "${BUILD_DIR}"
	pushd "${BUILD_DIR}" >/dev/null

	local CROSS_COMPILE="${TOOLCHAIN_DIR}/bin/arm-linux-gnueabihf-"

	"${PWD}/../${QT_SRC_DIR}/configure" \
		-release \
		-opengl es2 \
		-device linux-rasp-pi3-g++ \
		-device-option CROSS_COMPILE=${CROSS_COMPILE} \
		-sysroot "${SYSROOT_DIR}" \
		-opensource -confirm-license \
		-skip qtscript -skip qtwayland -skip qtdatavis3d -skip qtwebengine \
		-nomake examples -nomake tests \
		-prefix "${INSTALL_PREFIX}" \
		-qt-host-path "${HOST_PREFIX}" \
		-extprefix "${INSTALL_PREFIX}" \
		-pkg-config \
		-no-use-gold-linker \
		-DQT_HOST_PATH="${HOST_PREFIX}"

	popd >/dev/null
}

build_and_install() {
	msg "Building Qt (this may take a while)"
	pushd "${BUILD_DIR}" >/dev/null
	make -j$(nproc)
	msg "Installing Qt to ${INSTALL_PREFIX}"
	make install
	popd >/dev/null
}

###############################################
# Main execution flow
###############################################
ensure_toolchain
fetch_qt_source
create_sysroot
configure_qt
build_and_install

msg "Qt6 cross‑compilation for Raspberry Pi 3 completed successfully."
msg "Remember to set the following environment variables on the target device:"
echo "export QT_QPA_PLATFORM=eglfs"
echo "export QT_QPA_PLATFORM_PLUGIN_PATH=${INSTALL_PREFIX}/plugins/platforms"
echo "export LD_LIBRARY_PATH=${INSTALL_PREFIX}/lib"
