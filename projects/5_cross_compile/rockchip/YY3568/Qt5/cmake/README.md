# Qt5 cmake

Based on your directory structure, here is how your components map:

- **Linaro Cross-Compiler**: `/home/danial/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu`
- **Qt 5 Staging for RK3568**: `/home/danial/qt5-rk-deb10` (or `/home/danial/qt5rk.forRK3568`)
- **Sysroot**: `/home/danial/rk-deb10-sysroot`

- **OpenCV**: `/home/danial/opencv-rk-deb10`

Because your existing `toolchain.cmake` hardcodes `/usr/bin/aarch64-linux-gnu-` and pulls in specific Debian GCC flags, **do not overwrite it**. Instead, create a dedicated toolchain file for your Linaro Qt 5 build, then configure and compile.

---

### Step 1: Create `toolchain-qt5-linaro.cmake`

Save this file as `/home/danial/toolchain-qt5-linaro.cmake` (or inside your project root):

```cmake
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

```

---

### Step 2: Configure and Compile

Run this command from your terminal:

```bash
mkdir -p /home/danial/Code/novin-med/projects/laserscanner/laserscanner/build-cross-qt5
cd /home/danial/Code/novin-med/projects/laserscanner/laserscanner/build-cross-qt5

cmake .. \
  -DCMAKE_TOOLCHAIN_FILE=/home/danial/toolchain-qt5-linaro.cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_TESTING=OFF \
  -DQT_QMAKE_EXECUTABLE=/home/danial/qt5-rk-deb10/bin/qmake \
  -DCMAKE_PREFIX_PATH="/home/danial/qt5-rk-deb10;/home/danial/opencv-rk-deb10" \
  -DOpenCV_DIR=/home/danial/opencv-rk-deb10/lib/cmake/opencv4

```

_(If your cross-compiled Qt 5 directory is `qt5rk.forRK3568` instead of `qt5-rk-deb10`, substitute the path above accordingly)._

Then build the binary:

```bash
cmake --build . -j$(nproc)

```

---

### Step 3: Verify the Binary

Verify that the output executable is built for 64-bit ARM and dynamically linked:

```bash
file Laserscanner

```

You should see:

```text
Laserscanner: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), dynamically linked, ...

```
