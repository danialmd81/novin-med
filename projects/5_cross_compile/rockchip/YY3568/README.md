# YY3568 cross-compile Qt

[Debian source code (enable docker)](https://drive.google.com/drive/folders/1j5BHQcE6qPp0J_7wczSX9eZ_u1lgaYl6)

## sysroot

1. **YY3568-Debian10 rootfs image**

```bash
sudo mount -o loop,ro YY3568-Debian10/yy3568-debian10-rootfs/debian10-rootfs.img ./temp
cp -r ./temp/lib ./YY3568-Debian10-sysroot
cp -r ./temp/usr/include ./YY3568-Debian10-sysroot/usr
cp -r ./temp/usr/lib ./YY3568-Debian10-sysroot/usr
```

2. **fix relativelinks**

```bash
./sysroot-relativelinks.py YY3568-Debian10-sysroot
```

## toolchain

> i used YY3568-Debian10/prebuilts/gcc/linux-x86/aarch64/**gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu** from its sdk.

## configure

1. copy [linux-rkchip-yy3568-g++ config](./linux-rkchip-yy3568-g++/) to `qtsource/qtbase/mkspecs/device`.

2. use [configure.sh](./configure.sh) but fix its path.

> `-hostprefix` allows separating host tools like `qmake`, `rcc`, `uic` from the binaries for the target. When given, such tools will be installed under the specified directory instead of `extprefix`.
> `-extprefix` which defaults to `sysroot + prefix` and is therefore **optional**. However, in many cases "polluting" the sysroot is not desirable and thus specifying `-extprefix` becomes important.

## make & make install
