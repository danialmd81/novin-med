cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv7l)

# Sysroot configuration
set(TARGET_SYSROOT "/home/danial/rpi4-deb10-sysroot")
set(CMAKE_SYSROOT "${TARGET_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH "${TARGET_SYSROOT}")

# PkgConfig environment variables targeting the 32-bit sysroot
set(ENV{PKG_CONFIG_PATH} "${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${CMAKE_SYSROOT}/usr/share/pkgconfig")
set(ENV{PKG_CONFIG_LIBDIR} "${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${CMAKE_SYSROOT}/usr/lib/pkgconfig")
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${CMAKE_SYSROOT}")

# Cross Compilers
set(TOOLCHAIN_PREFIX "/usr/bin/arm-linux-gnueabihf-")
set(CMAKE_C_COMPILER "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_PREFIX}gcc")

# Compiler and Linker Flags (Tuned for 32-bit ARMv7-A Cortex-A72 with VFPv4/NEON)
set(QT_COMPILER_FLAGS "-march=armv7-a -marm -mfpu=neon-vfpv4 -mfloat-abi=hard --sysroot=${CMAKE_SYSROOT} -D_GNU_SOURCE=1 -D_ISOC99_SOURCE=1 -D__GLIBC_USE_ISOC2X=0 -D__GLIBC_USE_ISOC23=0 -D_ISOC2X_SOURCE=0 -D_ISOC23_SOURCE=0")
set(QT_COMPILER_FLAGS_RELEASE "-O2 -pipe")

set(CMAKE_C_FLAGS "${QT_COMPILER_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${QT_COMPILER_FLAGS} -std=gnu++17 -fpermissive" CACHE STRING "" FORCE)

# Linker flags targeting 32-bit library directories
set(QT_LINKER_FLAGS "--sysroot=${CMAKE_SYSROOT} -L${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf -L${CMAKE_SYSROOT}/lib/arm-linux-gnueabihf -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf -Wl,-rpath-link,${CMAKE_SYSROOT}/lib/arm-linux-gnueabihf")

# Search behaviors
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_BUILD_RPATH "${TARGET_SYSROOT}")

# Hook compiler & linker flags into CMake initialization
include(CMakeInitializeConfigs)

function(cmake_initialize_per_config_variable _PREFIX _DOCSTRING)
  if (_PREFIX MATCHES "CMAKE_(C|CXX|ASM)_FLAGS")
    set(CMAKE_${CMAKE_MATCH_1}_FLAGS_INIT "${QT_COMPILER_FLAGS}")
        
    foreach (config DEBUG RELEASE MINSIZEREL RELWITHDEBINFO)
      if (DEFINED QT_COMPILER_FLAGS_${config})
        set(CMAKE_${CMAKE_MATCH_1}_FLAGS_${config}_INIT "${QT_COMPILER_FLAGS_${config}}")
      endif()
    endforeach()
  endif()

  if (_PREFIX MATCHES "CMAKE_(SHARED|MODULE|EXE)_LINKER_FLAGS")
    foreach (config SHARED MODULE EXE)
      set(CMAKE_${config}_LINKER_FLAGS_INIT "${QT_LINKER_FLAGS}")
    endforeach()
  endif()

  _cmake_initialize_per_config_variable(${ARGV})
endfunction()

# Explicit Library and Header Overrides for EGLFS / GBM on Raspberry Pi 4 (32-bit Mesa VC4/V3D)
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

set(XCB_XCB_INCLUDE_DIR "${GL_INC_DIR}")
set(XCB_XCB_LIBRARY "${TARGET_SYSROOT}/usr/lib/arm-linux-gnueabihf/libxcb.so")

list(APPEND CMAKE_LIBRARY_PATH "${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf")
list(APPEND CMAKE_PREFIX_PATH "${CMAKE_SYSROOT}/usr/lib/arm-linux-gnueabihf/cmake")