#!/usr/bin/env bash

# ------------------------------------------------------------
# Qt6 Cross-Compilation Script for Raspberry Pi 3 (EGLFS)
# ------------------------------------------------------------
# Follows the official Qt documentation exactly:
#   https://doc.qt.io/qt-6/configure-linux-device.html
#   https://wiki.qt.io/Cross-Compile_Qt_6_for_Raspberry_Pi
#
# The docs' recommended approach combines:
#   - a CMake toolchain file (the actual compiler/sysroot config)
#   - -device / -device-option (kept only for qmake compatibility,
#     optional if you only ever build with CMake/qt-cmake)
#
# Adjust the variables below to match your environment before running.
# ------------------------------------------------------------

set -e

###############################################
# Configuration - edit these as needed
###############################################

# Device mkspec for a 32-bit Raspberry Pi 3 (Mesa/VC4 driver stack).
# Only needed for qmake compatibility - CMake builds don't require it.
DEVICE_MKSPEC="linux-rasp-pi3-vc4-g++"

CROSS_COMPILE="${HOME}/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"
# CROSS_COMPILE="/usr/bin/arm-linux-gnueabihf-"  # newer GCC - compiles Qt 6.9.3's C++20 fine, but its libstdc++ needs glibc symbols this sysroot's glibc doesn't have (__libc_single_threaded, close_range, pthread_cond_clockwait)
# CROSS_COMPILE="${HOME}/gcc-arm-11.2-2022.02-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-"  # wrong triplet for this sysroot

# Remote Raspberry-Pi device (SSH reachable)
RPI_HOST="root@rpi3device"

# Absolute path where the sysroot will be created on the host
SYSROOT_DIR="${HOME}/rpi3-sysroot"

# Qt source archive (already extracted from the everywhere-src tarball)
# NOTE: GCC 7.5 (Linaro, above) cannot compile Qt 6.9.3 - it needs C++20
# support Qt 6.5+ requires. Use Qt 6.2.x (LTS) instead, the last line
# that builds cleanly with GCC 7/8:
#   https://download.qt.io/official_releases/qt/6.2/6.2.4/single/
QT_VERSION="6.2.4"
QT_SRC_DIR="qt-everywhere-src-${QT_VERSION}"

# Existing host Qt install (from the Qt Online Installer) - MUST match
# QT_VERSION above exactly, or cross-configure fails with a version
# mismatch. Your installed host Qt is 6.9.3 - install a matching 6.2.4
# desktop Qt via the Qt Online Installer, or this will fail.
QT_HOST_PATH="${HOME}/Qt/6.2.4/gcc_64"

# Build / staging / final install directories, per the docs' naming:
#   BUILD_DIR      -> where configure/ninja run
#   STAGING_DIR    -> "$HOME/qt6-rpi" in the docs (-extprefix): the local
#                     copy you build apps against and rsync to the device
#   INSTALL_PREFIX -> "/usr/local/qt6" in the docs (-prefix): the path
#                     baked into rpaths, i.e. where it must live ON THE PI
BUILD_DIR="$(pwd)/build"
STAGING_DIR="$(pwd)/qt6-rpi"
INSTALL_PREFIX="/usr/local/qt6pi"

TOOLCHAIN_FILE="$(pwd)/toolchain.cmake" # standalone file - edit its
# TARGET_SYSROOT/CROSS_COMPILER

###############################################
# Helper functions
###############################################
msg() {
	echo -e "\033[1;34m[qt6-cross]\033[0m $*"
}

ensure_toolchain() {
	if [[ ! -x "${CROSS_COMPILE}gcc" ]]; then
		msg "Toolchain not found at ${CROSS_COMPILE}gcc. Please download and extract it first."
		exit 1
	fi
	export PATH="$(dirname "${CROSS_COMPILE}"):${PATH}"
	msg "Toolchain added to PATH"
}

check_qt_source() {
	if [[ -d "${QT_SRC_DIR}" ]]; then
		msg "Qt source already present: ${QT_SRC_DIR}"
		return
	fi
	msg "there is no ${QT_SRC_DIR} directory."
	exit 1
}

check_toolchain_file() {
	if [[ ! -f "${TOOLCHAIN_FILE}" ]]; then
		msg "toolchain.cmake not found at ${TOOLCHAIN_FILE}."
		exit 1
	fi
	msg "Using toolchain file ${TOOLCHAIN_FILE}"
}

create_sysroot() {
	msg "Creating sysroot directory ${SYSROOT_DIR}"
	mkdir -p "${SYSROOT_DIR}" "${SYSROOT_DIR}/usr" "${SYSROOT_DIR}/opt"
	msg "Syncing libraries and headers from the Raspberry-Pi"
	rsync -avz "${RPI_HOST}:/lib" "${SYSROOT_DIR}" || true
	rsync -avz "${RPI_HOST}:/lib/arm-linux-gnueabihf" "${SYSROOT_DIR}/lib/"
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
	msg "Configuring Qt for cross-compilation"
	mkdir -p "${BUILD_DIR}" "${STAGING_DIR}"
	pushd "${BUILD_DIR}" >/dev/null

	"${PWD}/../${QT_SRC_DIR}/configure" \
		-release \
		-opengl es2 \
		-nomake examples -nomake tests \
		-opensource -confirm-license \
		-skip qtscript -skip qtwayland -skip qtdatavis3d -skip qtwebengine -skip qtgrpc -skip qtopcua \
		-qt-host-path "${QT_HOST_PATH}" \
		-extprefix "${STAGING_DIR}" \
		-prefix "${INSTALL_PREFIX}" \
		-device "${DEVICE_MKSPEC}" \
		-device-option CROSS_COMPILE="${CROSS_COMPILE}" \
		-- \
		-DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}"

	popd >/dev/null
}

build_and_install() {
	msg "Building Qt (this may take a while)"
	pushd "${BUILD_DIR}" >/dev/null
	cmake --build . --parallel
	msg "Installing Qt to staging dir ${STAGING_DIR}"
	# Per the docs: install goes to the STAGING dir (-extprefix), not the
	# final device path - no sudo needed here since this is just a local
	# host-side directory you build apps against and later rsync to the Pi.
	cmake --install .
	popd >/dev/null
}

deploy_to_pi() {
	msg "Deploying ${STAGING_DIR} to ${RPI_HOST}:${INSTALL_PREFIX}"

	ssh "${RPI_HOST}" "mkdir -p '${INSTALL_PREFIX}'"

	rsync -avz --delete \
		"${STAGING_DIR}/" \
		"${RPI_HOST}:${INSTALL_PREFIX}/"

	msg "Writing environment profile to the device"
	ssh "${RPI_HOST}" "cat > /etc/profile.d/qt6pi.sh" <<-EOF
		export QT_QPA_PLATFORM=eglfs
		export QT_QPA_PLATFORM_PLUGIN_PATH=${INSTALL_PREFIX}/plugins/platforms
		export LD_LIBRARY_PATH=${INSTALL_PREFIX}/lib:\${LD_LIBRARY_PATH}
	EOF
	ssh "${RPI_HOST}" "chmod +x /etc/profile.d/qt6pi.sh"

	msg "Deployed. New SSH sessions on the Pi will pick up the env vars automatically."
	msg "For the current session run: source /etc/profile.d/qt6pi.sh"
}

###############################################
# Main execution flow
###############################################
ensure_toolchain
check_qt_source
check_toolchain_file
create_sysroot
configure_qt
build_and_install
deploy_to_pi

msg "Qt6 cross-compilation and deployment for Raspberry Pi 3 completed successfully."
msg "Build apps against ${STAGING_DIR}/bin/qt-cmake (see doc.qt.io/qt-6/configure-linux-device.html)."
