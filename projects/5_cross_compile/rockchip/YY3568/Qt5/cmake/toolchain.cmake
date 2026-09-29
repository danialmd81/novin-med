cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 1. Sysroot
set(TARGET_SYSROOT "/home/danial/rk-deb10-sysroot")
set(CMAKE_SYSROOT "${TARGET_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH "${TARGET_SYSROOT}")

# 2. Linaro Cross-Compilers
set(LINARO_ROOT "/home/danial/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu")
set(CMAKE_C_COMPILER   "${LINARO_ROOT}/bin/aarch64-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "${LINARO_ROOT}/bin/aarch64-linux-gnu-g++")

# 3. PkgConfig targeting target sysroot
set(ENV{PKG_CONFIG_PATH} "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_LIBDIR} "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}/usr/lib/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${CMAKE_SYSROOT}")

# 4. Compiler & Linker Flags (matching Linaro ARMv8-A)
set(CMAKE_C_FLAGS   "-march=armv8-a --sysroot=${CMAKE_SYSROOT} -O2 -pipe" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "-march=armv8-a --sysroot=${CMAKE_SYSROOT} -std=gnu++17 -O2 -pipe" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT} -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -L${CMAKE_SYSROOT}/lib/aarch64-linux-gnu -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -Wl,-rpath-link,${CMAKE_SYSROOT}/lib/aarch64-linux-gnu" CACHE STRING "" FORCE)

# 5. Search policies
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)