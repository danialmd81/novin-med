cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv7l)

# 1. Sysroot Configuration
set(TARGET_SYSROOT "/home/danial/rpi4-buster-sysroot")
set(CMAKE_SYSROOT "${TARGET_SYSROOT}")

# 2. Search Paths
list(APPEND CMAKE_FIND_ROOT_PATH
    "${TARGET_SYSROOT}"
    "/home/danial/qt5-rpi4-deb10"
    "/home/danial/qt5-rpi4-host-tools"
    "/home/danial/opencv-rpi4-deb10"
)

# 3. Cross Compilers
set(TOOLCHAIN_PREFIX "/usr/bin/arm-linux-gnueabihf-")
set(CMAKE_C_COMPILER   "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++")

# 4. PkgConfig targeting Debian 10 armhf sysroot
set(ENV{PKG_CONFIG_PATH} "${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${CMAKE_SYSROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_LIBDIR} "${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${CMAKE_SYSROOT}/usr/lib/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${CMAKE_SYSROOT}")

# 5. Compiler & Linker Flags (ARMv7-A Hard Float)
set(QT_COMPILER_FLAGS "-march=armv7-a -marm -mfpu=neon-vfpv4 -mfloat-abi=hard --sysroot=${CMAKE_SYSROOT} -D_GNU_SOURCE=1 -O2 -pipe")
set(CMAKE_C_FLAGS   "${QT_COMPILER_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${QT_COMPILER_FLAGS} -std=gnu++17" CACHE STRING "" FORCE)

set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT} -L${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf -L${CMAKE_SYSROOT}/lib/arm-linux-gnueabihf -Wl,-O1 -Wl,--as-needed -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf -Wl,-rpath-link,${CMAKE_SYSROOT}/lib/arm-linux-gnueabihf" CACHE STRING "" FORCE)

# 6. Search policies
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)

# 7. EGL / DRM Library Paths for RPi4
set(GL_INC_DIR "${CMAKE_SYSROOT}/usr/include")
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