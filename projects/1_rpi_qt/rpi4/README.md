---
title: ""
author: []
date: "Azar 1404"
geometry: margin=1in
fontsize: 12pt
mainfont: "DejaVu Sans"
monofont: "DejaVu Sans Mono"
sansfont: "Arial"
linkcolor: blue
urlcolor: blue
header-includes:
  - \usepackage{fvextra}
  - \DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,breakanywhere,fontsize=\footnotesize,commandchars=\\\{\},breaksymbolleft={},breaksymbolright={}}
  - \makeatletter
  - \renewcommand{\maketitle}{
      \begin{center}
        {\LARGE \@title \par}
        {\large \@date \par}
      \end{center}
    }
  - \makeatother
---
# Cross-Compiling Qt 6 for Raspberry Pi 4 (Lite, No Desktop UI)

A step-by-step guide to cross-compile Qt 6 on Ubuntu for **Raspberry Pi OS Lite** (no graphical desktop).  
**Goal:** Build Qt 6 apps on your PC and run them directly on your Pi's framebuffer (EGLFS or LinuxFB), without X11.

---

## Table of Contents

1. [Overview & Planning](#overview--planning)
2. [Prepare Raspberry Pi OS Lite](#prepare-raspberry-pi-os-lite)
3. [Prepare Raspberry Pi (Lite, No GUI)](#prepare-raspberry-pi-lite-no-gui)
4. [Prepare Host (Ubuntu) PC](#prepare-host-ubuntu-pc)
5. [Set Up SSH](#set-up-ssh)
6. [Create Sysroot](#create-sysroot)
7. [Build Qt 6](#build-qt-6)
    - [For Host](#build-qt-6-for-host)
    - [For Raspberry Pi (EGLFS/LinuxFB)](#build-qt-6-for-raspberry-pi-eglfslinuxfb)
8. [Deploy & Configure on Pi](#deploy--configure-on-pi)
9. [Build & Run Qt Apps (No X11)](#build--run-qt-apps-no-x11)
10. [Troubleshooting](#troubleshooting)
11. [References](#references)

---

## 1. Overview & Planning

**Key directories (on your PC):**

- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/rpi-sysroot` — Pi's root filesystem (sysroot)
- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/qt-everywhere-src-6.9.3/qtbase` — Qt source code
- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/qt-host` — Qt build for your PC
- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/qt-raspi` — Qt build for Pi
- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/qt-hostbuild` — Build files for host Qt
- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/qtpi-build` — Build files for Pi Qt
- `/home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/toolchain.cmake` — CMake toolchain file

**Create directories:**

```sh
cd /home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4
mkdir rpi-sysroot rpi-sysroot/usr rpi-sysroot/opt
mkdir qt-host qt-raspi qt-hostbuild qtpi-build
```

---

## 2. Prepare Raspberry Pi OS Lite

- Download and flash [Raspberry Pi OS Lite](https://www.raspberrypi.com/software/) to a microSD card.
- This version has **no desktop UI** (no X11, no Wayland).

---

## 3. Prepare Raspberry Pi (Lite, No GUI)

1. **Boot Pi** and complete setup.
2. **Update system:**

    ```sh
    sudo apt update
    sudo apt full-upgrade
    sudo reboot
    ```

3. **Install minimal dependencies for Qt (no X11):**

    ```sh
    sudo apt-get install libudev-dev libinput-dev libts-dev libmtdev-dev \
      libjpeg-dev libfontconfig1-dev libssl-dev libdbus-1-dev libglib2.0-dev \
      libegl1-mesa-dev libgbm-dev libgles2-mesa-dev mesa-common-dev libasound2-dev \
      libpulse-dev libvpx-dev libsrtp2-dev libsnappy-dev libnss3-dev flex bison \
      libxslt-dev ruby gperf libbz2-dev libcups2-dev libfreetype6-dev libicu-dev \
      libsqlite3-dev libxslt1-dev libdrm-dev libatspi2.0-dev libcap-dev libaudio-dev
    ```

    - **Do NOT install any X11/XCB/Xlib packages.**
    - For touchscreen or input support, add `tslib` and related drivers if needed.

4. **Create Qt install directory:**

    ```sh
    sudo mkdir /usr/local/qt6
    ```

---

## 4. Prepare Host (Ubuntu) PC

1. **Update system:**

    ```sh
    sudo apt update
    sudo apt upgrade
    ```

2. **Install build tools and Qt dependencies:**

    ```sh
    sudo apt-get install make cmake build-essential libclang-dev clang ninja-build gcc git bison \
      python3 gperf pkg-config libfontconfig1-dev libfreetype6-dev libdrm-dev libinput-dev \
      libudev-dev libegl1-mesa-dev libgbm-dev libgles2-mesa-dev
    ```

3. **Install cross-compiler:**

    ```sh
    sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
    ```

- We used Linaro toolchain:

    <https://releases.linaro.org/components/toolchain/binaries/>

---

## 5. Set Up SSH

- Enable SSH on the Pi (`sudo raspi-config` or add `ssh` file to boot partition).
- Ensure you can SSH from your PC to the Pi.

---

## 6. Create Sysroot

1. **Install rsync and symlinks:**

    ```sh
    sudo apt install rsync symlinks
    ```

2. **Copy Pi filesystem to your PC (replace `<pi_user>` and `<pi_ip>`):**

    ```sh
    cd /home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4
    rsync -avzS --delete <pi_user>@<pi_ip>:/lib/* rpi-sysroot/lib
    mkdir -p rpi-sysroot/usr
    rsync -avzS --delete <pi_user>@<pi_ip>:/usr/include/* rpi-sysroot/usr/include
    rsync -avzS --delete <pi_user>@<pi_ip>:/usr/lib/* rpi-sysroot/usr/lib
    mkdir -p rpi-sysroot/opt
    rsync -avzS --delete <pi_user>@<pi_ip>:/opt/vc rpi-sysroot/opt/vc
    ```

3. **Fix symlinks:**

    ```sh
    symlinks -rc rpi-sysroot
    ```

---

## 7. Build Qt 6

### Build Qt 6 for Host

1. **Get Qt source:**

    <!-- Download and extract or clone Qt source as needed -->

2. **Build for host:**

    ```sh
    mkdir qt-hostbuild
    cd qt-hostbuild
    cmake ../qt-everywhere-src-6.9.3/qtbase/ -GNinja -DCMAKE_BUILD_TYPE=Release \
      -DQT_BUILD_EXAMPLES=OFF -DQT_BUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=../qt-host
    cmake --build . --parallel 8
    cmake --install .
    ```

### Build Qt 6 for Raspberry Pi (EGLFS/LinuxFB)

1. **Create toolchain file (`toolchain.cmake`):**

    ```cmake
    cmake_minimum_required(VERSION 3.18)
    include_guard(GLOBAL)

    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR arm)

    set(TARGET_SYSROOT /home/danial/Code/novin-med/projects/project1/rpi_qt/rpi4/rpi-sysroot)
    set(CMAKE_SYSROOT ${TARGET_SYSROOT})

    set(ENV{PKG_CONFIG_PATH} $PKG_CONFIG_PATH:/usr/lib/aarch64-linux-gnu/pkgconfig)
    set(ENV{PKG_CONFIG_LIBDIR} /usr/lib/pkgconfig:/usr/share/pkgconfig/:${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${TARGET_SYSROOT}/usr/lib/pkgconfig)
    set(ENV{PKG_CONFIG_SYSROOT_DIR} ${CMAKE_SYSROOT})

    # if you use other version of gcc and g++ than gcc/g++ 9, you must change the following variables

    set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
    set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${TARGET_SYSROOT}/usr/include")
    set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")

    set(QT_COMPILER_FLAGS "-march=armv8-a")
    set(QT_COMPILER_FLAGS_RELEASE "-O2 -pipe -DNDEBUG")
    set(QT_LINKER_FLAGS "-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed")

    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
    set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    set(CMAKE_BUILD_RPATH ${TARGET_SYSROOT})

    include(CMakeInitializeConfigs)

    function(cmake_initialize_per_config_variable _PREFIX_DOCSTRING)
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

    set(XCB_PATH_VARIABLE ${TARGET_SYSROOT})

    set(GL_INC_DIR ${TARGET_SYSROOT}/usr/include)
    set(GL_LIB_DIR ${TARGET_SYSROOT}:${TARGET_SYSROOT}/usr/lib/aarch64-linux-gnu/:${TARGET_SYSROOT}/usr:${TARGET_SYSROOT}/usr/lib)

    set(EGL_INCLUDE_DIR ${GL_INC_DIR})
    set(EGL_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libEGL.so)

    set(OPENGL_INCLUDE_DIR ${GL_INC_DIR})
    set(OPENGL_opengl_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libOpenGL.so)

    set(GLESv2_INCLUDE_DIR ${GL_INC_DIR})
    set(GLESv2_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libGLESv2.so)

    set(gbm_INCLUDE_DIR ${GL_INC_DIR})
    set(gbm_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libgbm.so)

    set(Libdrm_INCLUDE_DIR ${GL_INC_DIR})
    set(Libdrm_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libdrm.so)

    set(XCB_XCB_INCLUDE_DIR ${GL_INC_DIR})
    set(XCB_XCB_LIBRARY ${XCB_PATH_VARIABLE}/usr/lib/aarch64-linux-gnu/libxcb.so)
    ```

2. **Configure and build for EGLFS or LinuxFB (no X11):**

    ```sh
    cd qtpi-build
    ../qt-everywhere-src-6.9.3/qtbase/configure -release -opengl es2 -no-xcb -no-xkbcommon-x11 \
      -nomake examples -nomake tests \
      -qt-host-path ../qt-host \
      -extprefix ../qt-raspi \
      -prefix /usr/local/qt6 \
      -device linux-rasp-pi4-aarch64 -device-option CROSS_COMPILE=aarch64-linux-gnu- \
      -- -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake -DQT_QPA_DEFAULT_PLATFORM=eglfs
    cmake --build . --parallel 4
    cmake --install .
    ```

    - Use `-DQT_QPA_DEFAULT_PLATFORM=linuxfb` if you want LinuxFB instead of EGLFS.
    - `-no-xcb -no-xkbcommon-x11` disables X11 support.

---

## 8. Deploy & Configure on Pi

1. **Copy Qt to Pi (replace `<pi_user>` and `<pi_ip>`):**

    ```sh
    rsync -avz --rsync-path="sudo rsync" ../qt-raspi/* <pi_user>@<pi_ip>:/usr/local/qt6
    ```

2. **Set environment variables on Pi:**

    ```sh
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/qt6/lib/
    ```

---

## 9. Build & Run Qt Apps (No X11)

1. **On PC, build example:**

    ```sh
    cd qt-everywhere-src-6.9.3/qtbase/examples/gui/analogclock/
    ../../../../qt-raspi/bin/qt-cmake CMakeLists.txt
    cmake --build . --parallel 4
    cmake --install .
    ```

2. **Copy binary to Pi and run:**

    ```sh
    scp -r analogclock <pi_user>@<pi_ip>:/home/pi
    ssh <pi_user>@<pi_ip>
    cd /home/pi
    ./analogclock -platform eglfs
    # or
    ./analogclock -platform linuxfb
    ```

    - The app will display directly on the Pi's HDMI output (no desktop required).

---

## 10. Troubleshooting

- **No display:**  
  Make sure you are running on the Pi's console (not over SSH with no display attached).
- **Touchscreen/input issues:**  
  Install and configure `tslib` or other input drivers as needed.
- **Missing libraries:**  
  Ensure all required `.so` files are present in `/usr/local/qt6/lib` and your sysroot.
- **Environment variables not persistent:**  
  Add `export LD_LIBRARY_PATH=...` to `~/.bashrc` on the Pi.

---

## 11. References

- [Qt for Embedded Linux](https://doc.qt.io/qt-6/embedded-linux.html)
- [Qt EGLFS Platform](https://doc.qt.io/qt-6/embedded-linux.html#eglfs)
- [Qt LinuxFB Platform](https://doc.qt.io/qt-6/embedded-linux.html#linuxfb)
- [CMake Toolchains](https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html)

---
