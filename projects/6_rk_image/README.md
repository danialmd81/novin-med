# Custom Buildroot Firmware Guide for YY3568 (RK3568)

Complete step-by-step instructions to build custom Linux firmware featuring:

- Qt5 with hardware-accelerated EGLFS (GBM / DRM/KMS backend).
- OpenCV 3 with V4L2/video decoding support.
- Wi-Fi networking tools.
- eDP-1 display enabled with a 90-degree hardware/KMS screen rotation.

---

## 0. Extract the SDK Archive

Run on your host machine to concatenate and decompress the multi-part archive:

```bash
cat YY3568-Debian10.tar.gz.0* | tar -xzv
cd YY3568-Debian10
git reset --hard HEAD

```

---

## 1. Container Setup on Host (Podman)

Run these commands on your Linux host machine to import and launch the SDK container environment.

### 1.1 Import the Container Image

Imports the provided build environment archive into your local container storage.

```bash
podman import docker/youyeetoo-ubuntu20.04.tar yyt-ubuntu:20.04

```

### 1.2 Start the Build Container

Launches the container matching your host user ID/GID, keeping directory ownership intact while mounting the SDK workspace (`6_rk_image`) to `/home/youyeetoo`.

```bash
podman run -d -it --name youyeetoo \
  --privileged \
  --userns=keep-id:uid=1000,gid=1000 \
  -v "$(pwd)":/home/youyeetoo:z \
  yyt-ubuntu:20.04 /bin/bash

podman exec -u youyeetoo -ti -w /home/youyeetoo youyeetoo /bin/bash

```

---

## 2. Board Profile Configuration

Run inside the container (`youyeetoo@<container_id>:~$`).

### 2.1 Create a Custom Board Configuration

Duplicates the existing Debian board profile as a baseline.

```bash
cp device/rockchip/rk356x/YY3568-Debian10.mk device/rockchip/rk356x/YY3568-Buildroot.mk

```

### 2.2 Switch Target Filesystem to Buildroot

Point the rootfs target to Buildroot and configure the packaging file:

```bash
sed -i 's/export RK_ROOTFS_SYSTEM=debian/# export RK_ROOTFS_SYSTEM=debian/' device/rockchip/rk356x/YY3568-Buildroot.mk
sed -i '/export RK_ROOTFS_SYSTEM=/a export RK_ROOTFS_SYSTEM=buildroot\nexport RK_PACKAGE_FILE=rk356x-package-file' device/rockchip/rk356x/YY3568-Buildroot.mk

```

### 2.3 Activate Board Profile

Selects the newly created board configuration as the active target.

```bash
./build.sh lunch

```

Select the menu entry corresponding to `YY3568-Buildroot.mk` (typically combo `10`).

Verify active configuration:

```bash
ls -l device/rockchip/.BoardConfig.mk
cat device/rockchip/.BoardConfig.mk | grep RK_ROOTFS_SYSTEM

```

---

## 3. Buildroot Package & Driver Configuration

Configures the cross-compilation toolchain, Mali GPU acceleration, Qt5 modules, OpenCV 3, and Wi-Fi drivers.

### 3.1 Initialize and Open Menuconfig

```bash
cd /home/youyeetoo/buildroot
make rockchip_rk3568_defconfig
make menuconfig

```

### 3.2 Required Menu Settings

Ensure the following options are selected:

- **Toolchain (`Toolchain --->`)**
  - `[*] Enable C++ support`
  - `[*] Enable WCHAR support`
  - `[*] Enable thread support`

- **Rockchip Hardware Drivers (`Target packages ---> Rockchip BSP packages --->`)**
  - `[*] rockchip libmali`
  - `display platform (gbm) --->` _(Must be **`gbm`**, NOT `wayland`)_
  - `[*] Rockchip RGA lib for linux`
  - `[*] MPP(Multimedia Processing Platform)`
  - `[*] rkwifibt`

- **Graphic Engine & Qt5 (`Target packages ---> Graphic libraries and applications --->`)**
  - `[*] kmscube`
  - `[ ] weston` _(Must be disabled to prevent DRM device conflicts)_
  - `[*] Qt5 --->` -> `[*] qt5base --->`:
    - `[*] gui module`
    - `[*] widgets module`
    - `OpenGL support: OpenGL ES 2.0+`
    - Platform plugins:
      - `[*] EGLFS support`
      - `[*] KMS/DRM backend`
      - `[*] libinput support`
    - `[*] Enable RGA`
    - Additional Qt Modules:
      - `[*] qt5declarative` -> `[*] quick module`
      - `[*] qt5graphicaleffects`
      - `[*] qt5imageformats`
      - `[*] qt5multimedia`
      - `[*] qt5quickcontrols2`
      - `[*] qt5tools`
- **OpenCV 3 (`Target packages ---> Libraries ---> Graphics ---> opencv3`)**
  - Core modules: `[*] highgui`, `[*] imgcodecs`, `[*] imgproc`, `[*] video`, `[*] videoio`
  - 3rd party support: `[*] ffmpeg support`, `[*] jpeg support`, `[*] png support`, `[*] v4l support`
- **Networking (`Target packages ---> Networking applications --->`)**
  - `[*] wpa_supplicant` (`[*] nl80211 support`, `[*] wpa_cli`)
  - `[*] wireless-tools`
  - `[*] iw`

### 3.3 Save Defconfig

Saves the configuration to prevent settings from getting overwritten on clean builds:

```bash
make savedefconfig
cd /home/youyeetoo

```

---

## 4. Display Output & Rotation Overlay

Directs Qt5 to render directly over DRM/KMS to the `eDP-1` connector rotated 90 degrees.

### 4.1 Create Overlay Directories

```bash
mkdir -p buildroot/board/rockchip/common/base/etc/profile.d

```

### 4.2 Create KMS Configuration (`/etc/kms.conf`)

Forces Qt's EGLFS platform plugin to render to `eDP-1` with 90° rotation:

```bash
cat << 'EOF' > buildroot/board/rockchip/common/base/etc/kms.conf
{
  "device": "/dev/dri/card0",
  "hwcursor": false,
  "pbuffers": true,
  "outputs": [
    {
      "name": "eDP-1",
      "mode": "off",
      "transform": "rotate-90"
    }
  ]
}
EOF

```

### 4.3 Configure Qt Runtime Environment (`/etc/profile.d/qt_eglfs.sh`)

Defines environment variables loaded at boot:

```bash
cat << 'EOF' > buildroot/board/rockchip/common/base/etc/profile.d/qt_eglfs.sh
export QT_QPA_PLATFORM=eglfs
export QT_QPA_EGLFS_KMS_CONFIG=/etc/kms.conf
export QT_QPA_EGLFS_INTEGRATION=eglfs_kms
export QT_QPA_ENABLE_TERMINAL_KEYBOARD=1
EOF

chmod +x buildroot/board/rockchip/common/base/etc/profile.d/qt_eglfs.sh

```

### 4.4 Verify Overlay Registration

Confirm that `board/rockchip/common/base` is present in the active overlay paths:

```bash
grep "BR2_ROOTFS_OVERLAY" buildroot/.config

```

---

## 5. Kernel Device Tree (DTS) Configuration

Switch display multiplexing from MIPI-DSI to eDP-1:

```bash
sed -i 's/#define DISPLAY_SWITCH 0/#define DISPLAY_SWITCH 2/' kernel/arch/arm64/boot/dts/rockchip/rk3568-evb1-ddr4-v10-linux.dts

```

_Verification: Run `sed -n '10,35p' kernel/arch/arm64/boot/dts/rockchip/rk3568-evb1-ddr4-v10-linux.dts` to verify `#define DISPLAY_SWITCH 2` imports `rk3568-vp1-edp-1080p.dtsi`._

---

## 6. Upstream BSP Bugfixes & Workarounds

Apply these patches to resolve expired third-party download links and Rockchip out-of-tree package build discrepancies.

### 6.1 Fix bzip2 Download Mirror (Dead Domain Fix)

`bzip.org` returns an HTML redirect instead of a valid archive. Pre-populate the cache manually:

```bash
rm -f /home/youyeetoo/buildroot/dl/bzip2-1.0.6.tar.gz
rm -rf /home/youyeetoo/buildroot/output/build/bzip2-1.0.6
mkdir -p /home/youyeetoo/buildroot/dl/bzip2

wget -c https://sourceware.org/pub/bzip2/bzip2-1.0.6.tar.gz -O /home/youyeetoo/buildroot/dl/bzip2-1.0.6.tar.gz
mv /home/youyeetoo/buildroot/dl/bzip2-1.0.6.tar.gz /home/youyeetoo/buildroot/dl/bzip2/
file /home/youyeetoo/buildroot/dl/bzip2/bzip2-1.0.6.tar.gz

```

### 6.2 Fix Rockchip MPP Version Template & Syntax

Rockchip MPP expects Git metadata definitions that are omitted in out-of-tree tarball builds. Populate the template and patch `mpp_info.cpp`:

```bash
mkdir -p /home/youyeetoo/external/mpp/build/cmake
mkdir -p /home/youyeetoo/external/mpp/mpp
mkdir -p /home/youyeetoo/external/mpp/inc

cat << 'EOF' > /home/youyeetoo/external/mpp/build/cmake/version.in
#ifndef __MPP_VERSION_H__
#define __MPP_VERSION_H__

#define MPP_VER_HIST_COUNT 1
#define MPP_VER_HIST_CNT   1
#define MPP_VERSION        "release"
#define MPP_VER_GIT_AUTHOR "rockchip"
#define MPP_VER_GIT_DATE   "2026-01-01"
#define MPP_VER_GIT_BRANCH "release"
#define MPP_VER_GIT_COMMIT "release"

#define MPP_VER_HIST_0 "Initial release"
#define MPP_VER_HIST_1 "none"
#define MPP_VER_HIST_2 "none"
#define MPP_VER_HIST_3 "none"
#define MPP_VER_HIST_4 "none"
#define MPP_VER_HIST_5 "none"
#define MPP_VER_HIST_6 "none"
#define MPP_VER_HIST_7 "none"
#define MPP_VER_HIST_8 "none"
#define MPP_VER_HIST_9 "none"

#endif
EOF

# Ensure version headers are in place across include locations
cp /home/youyeetoo/external/mpp/build/cmake/version.in /home/youyeetoo/external/mpp/mpp/mpp_version.h
cp /home/youyeetoo/external/mpp/build/cmake/version.in /home/youyeetoo/external/mpp/inc/mpp_version.h

# If the package was already extracted, patch the working build directory
if [ -d "/home/youyeetoo/buildroot/output/build/mpp-release" ]; then
    mkdir -p /home/youyeetoo/buildroot/output/build/mpp-release/build/cmake
    mkdir -p /home/youyeetoo/buildroot/output/build/mpp-release/mpp
    mkdir -p /home/youyeetoo/buildroot/output/build/mpp-release/inc
    cp /home/youyeetoo/external/mpp/build/cmake/version.in /home/youyeetoo/buildroot/output/build/mpp-release/build/cmake/version.in
    cp /home/youyeetoo/external/mpp/build/cmake/version.in /home/youyeetoo/buildroot/output/build/mpp-release/mpp/mpp_version.h
    cp /home/youyeetoo/external/mpp/build/cmake/version.in /home/youyeetoo/buildroot/output/build/mpp-release/inc/mpp_version.h
    find /home/youyeetoo/buildroot/output/build/mpp-release/ -name "*version*.h" -exec cp /home/youyeetoo/external/mpp/build/cmake/version.in {} \;
    sed -i 's/static const RK_S32 mpp_history_cnt = MPP_VER_HIST_CNT;/static const RK_S32 mpp_history_cnt = 1;/' /home/youyeetoo/buildroot/output/build/mpp-release/mpp/mpp_info.cpp
    rm -f /home/youyeetoo/buildroot/output/build/mpp-release/.stamp_configured
fi

if [ -f "/home/youyeetoo/external/mpp/mpp/mpp_info.cpp" ]; then
    sed -i 's/static const RK_S32 mpp_history_cnt = MPP_VER_HIST_CNT;/static const RK_S32 mpp_history_cnt = 1;/' /home/youyeetoo/external/mpp/mpp/mpp_info.cpp
fi

```

### 6.3 Fix RKNPU2 Library Path Layout

Legacy Buildroot recipes expect headers and pre-built binaries at `Linux/librknn_api`, whereas the source organizes them by SoC family (`runtime/RK356X/Linux`):

```bash
# Patch external source tree
if [ -d "/home/youyeetoo/external/rknpu2/runtime/RK356X/Linux" ] && [ ! -d "/home/youyeetoo/external/rknpu2/Linux" ]; then
    ln -sf runtime/RK356X/Linux /home/youyeetoo/external/rknpu2/Linux
fi

# Patch active build directory if already extracted
if [ -d "/home/youyeetoo/buildroot/output/build/rknpu2-1.1.0" ]; then
    cd /home/youyeetoo/buildroot/output/build/rknpu2-1.1.0
    ln -sf runtime/RK356X/Linux ./Linux
    cd /home/youyeetoo
fi

```

### 6.4 Fix MAC address

```bash
cat << 'EOF' > buildroot/board/rockchip/common/base/etc/init.d/S39setmac
#!/bin/sh
case "$1" in
  start)
    echo "Configuring static MAC address for eth0..."
    ip link set dev eth0 down
    ip link set dev eth0 address 5A:89:92:FE:D6:26
    ip link set dev eth0 up
    ;;
  *)
    exit 0
    ;;
esac
EOF
chmod +x buildroot/board/rockchip/common/base/etc/init.d/S39setmac

```

---

## 7. Build the Firmware

### 7.1 Setup Packaging Tool Symlinks

Link the Rockchip packaging tools:

```bash
cd /home/youyeetoo/tools/linux/Linux_Pack_Firmware/rockdev
ln -sf rk356x-mkupdate.sh mkupdate.sh

cd /home/youyeetoo/rockdev
ln -sf ../tools/linux/Linux_Pack_Firmware/rockdev/mkupdate.sh ./mkupdate.sh
ln -sf ../tools/linux/Linux_Pack_Firmware/rockdev/rk356x-mkupdate.sh ./rk356x-mkupdate.sh
ln -sf ../tools/linux/Linux_Pack_Firmware/rockdev/rkImageMaker ./rkImageMaker
ln -sf ../tools/linux/Linux_Pack_Firmware/rockdev/afptool ./afptool
ln -sf ../tools/linux/Linux_Pack_Firmware/rockdev/rk356x-package-file ./package-file

```

### 7.2 Compile Base Partitions (U-Boot & Kernel)

```bash
cd /home/youyeetoo
./build.sh 2>&1 | tee build.log

```

---

## 8. Packaging `update.img`

### 8.1 Compile the Buildroot Target Rootfs

Compile the actual rootfs with your selected Qt5 and driver configuration:

```bash
cd /home/youyeetoo/buildroot
make
cd /home/youyeetoo

```

_Verification: Ensure `buildroot/output/images/rootfs.ext4` is generated._

### 8.2 Symlink Buildroot Rootfs (Prevent Debian Fallback)

Ensure packaging links point directly to the newly compiled Buildroot filesystem:

```bash
cd /home/youyeetoo/rockdev
rm -f rootfs.ext4 rootfs.img
ln -sf ../buildroot/output/images/rootfs.ext4 ./rootfs.ext4
ln -sf rootfs.ext4 ./rootfs.img
cd /home/youyeetoo

```

### 8.3 Generate Unified Firmware Image

```bash
./build.sh updateimg

```

_Verification: Check image size (`ls -lh rockdev/update.img`). The generated firmware should be **~800 MB to 1.3 GB** (confirming Buildroot usage instead of the 4.0 GB Debian image)._

---

## 9. Flashing & Verification (Host Machine)

Execute on your Linux host outside the container.

### 9.1 Install `rkdeveloptool`

```bash
sudo apt update
sudo apt install -y libusb-1.0-0-dev libudev-dev pkg-config git build-essential cmake
git clone [https://github.com/rockchip-linux/rkdeveloptool.git](https://github.com/rockchip-linux/rkdeveloptool.git)
cd rkdeveloptool && cmake -B build && cmake --build build
sudo cp build/rkdeveloptool /usr/local/bin/

```

### 9.2 Flash Firmware

1. Connect the YY3568 USB Type-C OTG port to your PC.
2. Hold **Recovery**, press **Reset**, wait 3 seconds, and release.
3. Flash the firmware image:

```bash
cd 6_rk_image/rockdev
sudo rkdeveloptool ld
# sudo rkdeveloptool db MiniLoaderAll.bin    # (Only required if in Maskrom mode)
sudo rkdeveloptool wl 0x0 update.img
sudo rkdeveloptool rd

```

### 9.3 On-Board Validation

Once booted into Buildroot (`Welcome to RK356X Buildroot`), verify settings via serial or local terminal:

- **EGLFS Environment:** `env | grep QT_QPA` _(Should show `eglfs_kms` and `/etc/kms.conf`)._
- **Display Output:** `cat /sys/class/drm/card0-eDP-1/status` _(Should return `connected`)._
- **GPU & DRM Test:** `kmscube` _(A 3D cube should render smoothly on the display)._
- **Qt Apps & Rotation:** Run `qplayer` to confirm hardware acceleration and 90° orientation directly on `eDP-1`.
