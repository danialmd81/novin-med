cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv7l)

# ---------------------------------------------------------------------------
# 1. Target Sysroot & Staging Paths
# ---------------------------------------------------------------------------
# Target sysroot synced from Raspberry Pi 4 (Raspbian Buster armhf)
set(TARGET_SYSROOT "/home/danial/rpi4-deb10-sysroot")
set(CMAKE_SYSROOT "${TARGET_SYSROOT}")

# Staged directories for target libraries and headers
set(QT5_PREFIX "/home/danial/qt5-rpi4-deb10")
set(QT5_HOST_TOOLS "/home/danial/qt5-rpi4-host-tools")
set(OPENCV_PREFIX "/home/danial/opencv-rpi4-deb10")

# ---------------------------------------------------------------------------
# 2. Search Paths for CMake (find_package, find_library, find_path)
# ---------------------------------------------------------------------------
list(APPEND CMAKE_FIND_ROOT_PATH
    "${TARGET_SYSROOT}"
    "${QT5_PREFIX}"
    "${QT5_HOST_TOOLS}"
    "${OPENCV_PREFIX}"
)

# ---------------------------------------------------------------------------
# 3. Cross Compilers (GCC 8.3 triplet for Debian armhf)
# ---------------------------------------------------------------------------
set(TOOLCHAIN_PREFIX "/usr/bin/arm-linux-gnueabihf-")
set(CMAKE_C_COMPILER   "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++")

# ---------------------------------------------------------------------------
# 4. PkgConfig targeting Debian 10 armhf sysroot
# ---------------------------------------------------------------------------
set(ENV{PKG_CONFIG_PATH} "${QT5_PREFIX}/lib/pkgconfig:${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${TARGET_SYSROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_LIBDIR} "${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${TARGET_SYSROOT}/usr/lib/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${TARGET_SYSROOT}")

# ---------------------------------------------------------------------------
# 5. Compiler & Linker Flags (ARMv7-A Hard Float)
# ---------------------------------------------------------------------------
set(TARGET_ARCH_FLAGS "-march=armv7-a -marm -mfpu=neon-vfpv4 -mfloat-abi=hard --sysroot=${CMAKE_SYSROOT} -D_GNU_SOURCE=1")

set(CMAKE_C_FLAGS   "${TARGET_ARCH_FLAGS} -O2 -pipe" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${TARGET_ARCH_FLAGS} -O2 -pipe -std=gnu++17" CACHE STRING "" FORCE)

# Direct library paths
set(LIB_RPATHS
    "-L${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf \
     -L${TARGET_SYSROOT}/lib/arm-linux-gnueabihf \
     -L${QT5_PREFIX}/lib"
)

# Transitive runtime dependency resolution paths (-Wl,-rpath-link)
set(LINK_RPATHS
    "-Wl,-rpath-link,${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf \
     -Wl,-rpath-link,${TARGET_SYSROOT}/lib/arm-linux-gnueabihf \
     -Wl,-rpath-link,${QT5_PREFIX}/lib"
)

set(COMMON_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT} ${LIB_RPATHS} ${LINK_RPATHS} -Wl,-O1 -Wl,--as-needed")

set(CMAKE_EXE_LINKER_FLAGS    "${COMMON_LINKER_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_SHARED_LINKER_FLAGS "${COMMON_LINKER_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_MODULE_LINKER_FLAGS "${COMMON_LINKER_FLAGS}" CACHE STRING "" FORCE)

# ---------------------------------------------------------------------------
# 6. Search Policies: Look for programs only in host, libs/headers in sysroot
# ---------------------------------------------------------------------------
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# ---------------------------------------------------------------------------
# 7. Hardware Graphics / Mesa Library Targets for RPi4
# ---------------------------------------------------------------------------
set(GL_INC_DIR "${TARGET_SYSROOT}/usr/include")
set(EGL_INCLUDE_DIR "${GL_INC_DIR}")
set(EGL_LIBRARY "${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/libEGL.so")
set(GLESv2_INCLUDE_DIR "${GL_INC_DIR}")
set(GLESv2_LIBRARY "${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/libGLESv2.so")
set(OPENGL_INCLUDE_DIR "${GL_INC_DIR}")
set(OPENGL_opengl_LIBRARY "${GLESv2_LIBRARY}")
set(gbm_INCLUDE_DIR "${GL_INC_DIR}")
set(gbm_LIBRARY "${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/libgbm.so")
set(Libdrm_INCLUDE_DIR "${GL_INC_DIR}")
set(Libdrm_LIBRARY "${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/libdrm.so")