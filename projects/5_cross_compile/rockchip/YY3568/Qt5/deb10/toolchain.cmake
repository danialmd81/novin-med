cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# 1. Sysroot Configuration
set(TARGET_SYSROOT "/home/danial/rk-deb10-sysroot")
set(CMAKE_SYSROOT "${TARGET_SYSROOT}")

# 2. Allow searching sysroot AND staged cross-compiled directories
list(APPEND CMAKE_FIND_ROOT_PATH
    "${TARGET_SYSROOT}"
    "/home/danial/qt5-rk-deb10"
    "/home/danial/qt5-rk-host-tools"
    "/home/danial/opencv-rk-deb10"
)

# 3. Cross Compilers (GCC 8.3 triplet inside the container)
set(TOOLCHAIN_PREFIX "/usr/bin/aarch64-linux-gnu-")
set(CMAKE_C_COMPILER   "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++")

# 4. PkgConfig targeting Debian 10 sysroot
set(ENV{PKG_CONFIG_PATH} "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_LIBDIR} "${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}/usr/lib/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${CMAKE_SYSROOT}")

# 5. Compiler & Linker Flags
set(QT_COMPILER_FLAGS "-march=armv8-a --sysroot=${CMAKE_SYSROOT} -D_GNU_SOURCE=1 -O2 -pipe")
set(CMAKE_C_FLAGS   "${QT_COMPILER_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${QT_COMPILER_FLAGS} -std=gnu++17" CACHE STRING "" FORCE)

set(CMAKE_EXE_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT} -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -L${CMAKE_SYSROOT}/lib/aarch64-linux-gnu -Wl,-O1 -Wl,--as-needed -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -Wl,-rpath-link,${CMAKE_SYSROOT}/lib/aarch64-linux-gnu" CACHE STRING "" FORCE)

# 6. Search policies: Find target packages in sysroot and staging trees
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)

# 7. Explicit EGL / Mali / DRM library paths for RK3568
set(GL_INC_DIR "${CMAKE_SYSROOT}/usr/include")
set(EGL_INCLUDE_DIR "${GL_INC_DIR}")
set(EGL_LIBRARY "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/libEGL.so")
set(GLESv2_INCLUDE_DIR "${GL_INC_DIR}")
set(GLESv2_LIBRARY "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/libGLESv2.so")
set(OPENGL_INCLUDE_DIR "${GL_INC_DIR}")
set(OPENGL_opengl_LIBRARY "${GLESv2_LIBRARY}")
set(gbm_INCLUDE_DIR "${GL_INC_DIR}")
set(gbm_LIBRARY "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/libgbm.so")
set(Libdrm_INCLUDE_DIR "${GL_INC_DIR}")
set(Libdrm_LIBRARY "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/libdrm.so")