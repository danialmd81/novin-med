cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Sysroot configuration
set(TARGET_SYSROOT "$ENV{HOME}/rk-deb10-sysroot")
set(CMAKE_SYSROOT ${TARGET_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${TARGET_SYSROOT})

# PkgConfig environment variables targeting sysroot
set(ENV{PKG_CONFIG_SYSROOT_DIR} "${TARGET_SYSROOT}")
set(ENV{PKG_CONFIG_LIBDIR} "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${TARGET_SYSROOT}/usr/share/pkgconfig:${TARGET_SYSROOT}/usr/lib/pkgconfig")
set(ENV{PKG_CONFIG_PATH} "${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig")

# Cross Compilers (System Default g++ 11 or g++ 9 cross-toolchain)
set(TOOLCHAIN_PREFIX "/usr/bin/aarch64-linux-gnu-")
set(CMAKE_C_COMPILER "${TOOLCHAIN_PREFIX}gcc")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++")

set(CMAKE_AR "${TOOLCHAIN_PREFIX}ar" CACHE FILEPATH "Archiver")
set(CMAKE_RANLIB "${TOOLCHAIN_PREFIX}ranlib" CACHE FILEPATH "Ranlib")
set(CMAKE_STRIP "${TOOLCHAIN_PREFIX}strip" CACHE FILEPATH "Strip")

# C/C++ Flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${TARGET_SYSROOT}/usr/include -I${TARGET_SYSROOT}/usr/include/aarch64-linux-gnu")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")

set(QT_COMPILER_FLAGS "-march=armv8-a")
set(QT_COMPILER_FLAGS_RELEASE "-O2 -pipe -DNDEBUG")
set(QT_LINKER_FLAGS "-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed -L${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu -L${TARGET_SYSROOT}/lib/aarch64-linux-gnu -Wl,-rpath-link,${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu -Wl,-rpath-link,${TARGET_SYSROOT}/lib/aarch64-linux-gnu")

# Search behaviors
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_BUILD_RPATH ${TARGET_SYSROOT})

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

# Explicit Library and Header Overrides for EGLFS / GBM on RK3568
set(GL_INC_DIR ${TARGET_SYSROOT}/usr/include)
set(GL_LIB_DIR ${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu)

set(EGL_INCLUDE_DIR ${GL_INC_DIR})
set(EGL_LIBRARY ${GL_LIB_DIR}/libEGL.so)

set(OPENGL_INCLUDE_DIR ${GL_INC_DIR})
set(OPENGL_opengl_LIBRARY ${GL_LIB_DIR}/libOpenGL.so)

set(GLESv2_INCLUDE_DIR ${GL_INC_DIR})
set(GLESv2_LIBRARY ${GL_LIB_DIR}/libGLESv2.so)

set(gbm_INCLUDE_DIR ${GL_INC_DIR})
set(gbm_LIBRARY ${GL_LIB_DIR}/libgbm.so)

set(Libdrm_INCLUDE_DIR ${GL_INC_DIR})
set(Libdrm_LIBRARY ${GL_LIB_DIR}/libdrm.so)

set(XCB_XCB_INCLUDE_DIR ${GL_INC_DIR})
set(XCB_XCB_LIBRARY ${GL_LIB_DIR}/libxcb.so)