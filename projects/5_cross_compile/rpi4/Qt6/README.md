<https://wiki.qt.io/Cross-Compile_Qt_6_for_Raspberry_Pi>

- Sysroot, which basically is the scaled down version of our target's filesystem inside our host machine. For this example, we will name this

- A cross-compiler on host machine. To make it as straightforward as possible, for this guide we will use the cross-compiler for Aarch64 from the official Ubuntu package repository.

- Qt source code with its submodules, at least the qtbase submodule. For this guide, we will download Qt source code from Qt official GitHub repository. By default, it will be stored in

##

- We will store a build of Qt 6 for host machine on `qt-host`
- Finally, our Qt 6 build for Raspberry Pi will be stored on `qt-raspi`
- Following the best practices of building C/C++ applications, we also want to make sure that our final build directories are clean from all build configuration files that CMake will create during the configuration phase. For that, we will store build configuration files on `qt-hostbuild`
- for configuration files of Qt for our host machine and `qtpi-build`

## Install Cross Compiler

Next, let's get our cross-compiler. For this guide, we will install it from the Ubuntu/Debian package repository as this is the easiest way to get an ARM64 cross-compiler.

```bash
sudo apt install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
```

You can also download the cross-compiler from somewhere on the internet. If you want to do so, my recommendation is to check the [ARM official download page](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads) and choose which one fits your purpose.
