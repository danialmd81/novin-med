cmake_minimum_required(VERSION 3.18)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Sysroot configuration
set(TARGET_SYSROOT $ENV{SYSROOT_DIR})
set(CMAKE_SYSROOT ${TARGET_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${TARGET_SYSROOT})

# PkgConfig environment variables targeting sysroot
set(ENV{PKG_CONFIG_PATH} ${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig)
set(ENV{PKG_CONFIG_LIBDIR} ${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}/usr/lib/pkgconfig)
set(ENV{PKG_CONFIG_SYSROOT_DIR} ${CMAKE_SYSROOT})

# Cross Compilers
set(TOOLCHAIN_PREFIX $ENV{CROSS_COMPILE})
set(CMAKE_C_COMPILER "${TOOLCHAIN_PREFIX}gcc-9")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_PREFIX}g++-9")

# Fix: Add -B flags so GCC finds crt1.o, crti.o, crtn.o inside Debian multiarch sysroot
set(SYSROOT_DIR_FLAGS "--sysroot=${CMAKE_SYSROOT} -B${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -B${CMAKE_SYSROOT}/lib/aarch64-linux-gnu")

set(CMAKE_C_FLAGS "${SYSROOT_DIR_FLAGS} -I${CMAKE_SYSROOT}/usr/include -I${CMAKE_SYSROOT}/usr/include/aarch64-linux-gnu")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")

set(QT_COMPILER_FLAGS "-march=armv8-a")
set(QT_COMPILER_FLAGS_RELEASE "-O2 -pipe")

# Linker flags including -B search hints
set(QT_LINKER_FLAGS "${SYSROOT_DIR_FLAGS} -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed -L${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -L${CMAKE_SYSROOT}/lib/aarch64-linux-gnu -Wl,-rpath-link,${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu -Wl,-rpath-link,${CMAKE_SYSROOT}/lib/aarch64-linux-gnu")

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
set(XCB_PATH_VARIABLE ${TARGET_SYSROOT})

set(GL_INC_DIR ${CMAKE_SYSROOT}/usr/include)
set(GL_LIB_DIR ${TARGET_SYSROOT}:${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/:${CMAKE_SYSROOT}/usr:${CMAKE_SYSROOT}/usr/lib)

set(EGL_INCLUDE_DIR ${GL_INC_DIR})
set(EGL_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libEGL.so)

set(OPENGL_INCLUDE_DIR ${GL_INC_DIR})
set(OPENGL_opengl_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libOpenGL.so)

set(GLESv2_INCLUDE_DIR ${GL_INC_DIR})
set(GLIB_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libGLESv2.so)

set(gbm_INCLUDE_DIR ${GL_INC_DIR})
set(gbm_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libgbm.so)

set(Libdrm_INCLUDE_DIR ${GL_INC_DIR})
set(Libdrm_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libdrm.so)

set(XCB_XCB_INCLUDE_DIR ${GL_INC_DIR})
set(XCB_XCB_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libxcb.so)

list(APPEND CMAKE_LIBRARY_PATH ${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu)
list(APPEND CMAKE_PREFIX_PATH "/usr/lib/aarch64-linux-gnu/cmake")