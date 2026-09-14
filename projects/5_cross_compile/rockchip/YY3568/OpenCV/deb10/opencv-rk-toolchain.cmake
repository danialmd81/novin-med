cmake_minimum_required(VERSION 3.18)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# =========================
# Sysroot
# =========================
set(TARGET_SYSROOT "$ENV{SYSROOT_DIR}")

set(CMAKE_SYSROOT ${TARGET_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${TARGET_SYSROOT})

# =========================
# Cross compiler
# =========================
set(CMAKE_C_COMPILER "$ENV{CROSS_COMPILE}gcc")
set(CMAKE_CXX_COMPILER "$ENV{CROSS_COMPILE}g++")

# =========================
# Compiler flags
# =========================
set(CMAKE_C_FLAGS "-march=armv8-a")
set(CMAKE_CXX_FLAGS "-march=armv8-a")

# =========================
# Linker flags
# =========================
set(CMAKE_EXE_LINKER_FLAGS
    "--sysroot=${TARGET_SYSROOT} -L${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu -L${TARGET_SYSROOT}/lib/aarch64-linux-gnu -static-libstdc++ -static-libgcc"
)

set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS}"
)

# =========================
# pkg-config for sysroot
# =========================
set(ENV{PKG_CONFIG_PATH}
    "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig"
)

set(ENV{PKG_CONFIG_LIBDIR}
    "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:
     ${TARGET_SYSROOT}/usr/lib/pkgconfig"
)

set(ENV{PKG_CONFIG_SYSROOT_DIR}
    "${TARGET_SYSROOT}"
)

# =========================
# CMake search rules
# =========================
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# =========================
# Library search paths
# =========================
list(APPEND CMAKE_LIBRARY_PATH
    ${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu
    ${TARGET_SYSROOT}/lib/aarch64-linux-gnu
)