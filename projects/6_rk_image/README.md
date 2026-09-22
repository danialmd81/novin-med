# Custom Buildroot Firmware Guide for YY3568 (RK3568)

Complete step-by-step instructions to build custom Linux firmware featuring:

- Qt5 with hardware-accelerated EGLFS (GBM / DRM/KMS backend).
- OpenCV 3 with V4L2/video decoding support.
- Wi-Fi networking tools.
- eDP-1 display enabled with a 90-degree hardware/KMS screen rotation.

---

## 0. Extract the SDK Archive

```bash
cat YY3568-Debian10.tar.gz.0* | tar -xzv
cd YY3568-Debian
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

Replaces the Debian rootfs instruction with Buildroot and sets the default package file:

```bash
sed -i 's/export RK_ROOTFS_SYSTEM=debian/# export RK_ROOTFS_SYSTEM=debian/' device/rockchip/rk356x/YY3568-Buildroot.mk
sed -i '/export RK_ROOTFS_SYSTEM=/a export RK_ROOTFS_SYSTEM=buildroot\nexport RK_PACKAGE_FILE=rk356x-package-file' device/rockchip/rk356x/YY3568-Buildroot.mk

```

### 2.3 Activate Board Profile

Selects the newly created board configuration as the active target.

```bash
./build.sh lunch

```

_(Select the option corresponding to `YY3568-Buildroot.mk`, typically `10`)._

---

## 3. Buildroot Package & Driver Configuration

Configures the cross-compilation toolchain, Mali GPU acceleration, Qt5 modules, OpenCV 3, and Wi-Fi drivers.

### 3.1 Initialize and Open Menuconfig

```bash
cd buildroot
make rockchip_rk3568_defconfig
make menuconfig

```

### 3.2 Required Menu Settings

Set the following options in `menuconfig`:

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
- `[ ] weston` _(Must be unchecked to prevent DRM device conflicts)_
- `[*] Qt5 --->` -> `[*] qt5base --->`:
- `[*] gui module`
- `[*] widgets module`
- `OpenGL support: OpenGL ES 2.0+`
- Platform plugins:
- `[*] EGLFS support`
- `[*] KMS/DRM backend`
- `[*] libinput support`

- `[*] Enable RGA`

- Supporting Qt modules:
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

Directs Qt5 to render directly over DRM/KMS to the eDP-1 connector with a 90-degree screen rotation.

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

---

## 5. Kernel Device Tree (DTS) Configuration

Switches display routing from MIPI-DSI to eDP-1 in the kernel.

### 5.1 Set `DISPLAY_SWITCH` to eDP

Updates line 11 of the device tree to activate `rk3568-vp1-edp-1080p.dtsi`:

```bash
sed -i 's/#define DISPLAY_SWITCH 0/#define DISPLAY_SWITCH 2/' kernel/arch/arm64/boot/dts/rockchip/rk3568-evb1-ddr4-v10-linux.dts

```

---

## 6. Apply Upstream BSP Fixes

Run these patches inside `/home/youyeetoo` to prevent known vendor package compilation halts.

### 6.1 Fix bzip2 Download Mirror (Dead Domain Fix)

```bash
mkdir -p buildroot/dl/bzip2
wget -c [https://sourceware.org/pub/bzip2/bzip2-1.0.6.tar.gz](https://sourceware.org/pub/bzip2/bzip2-1.0.6.tar.gz) -O buildroot/dl/bzip2-1.0.6.tar.gz
cp buildroot/dl/bzip2-1.0.6.tar.gz buildroot/dl/bzip2/

```

### 6.2 Fix Rockchip MPP Version Template

```bash
mkdir -p external/mpp/build/cmake
cat << 'EOF' > external/mpp/build/cmake/version.in
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

```

### 6.3 Fix RKNPU2 Library Path Layout

```bash
if [ -d "external/rknpu2/runtime/RK356X/Linux" ] && [ ! -d "external/rknpu2/Linux" ]; then
    ln -sf runtime/RK356X/Linux external/rknpu2/Linux
fi

```

---

## 7. Build the Firmware

### 7.1 Compile U-Boot, Kernel, and Base Partition Images

```bash
cd /home/youyeetoo
./build.sh 2>&1 | tee build.log

```

### 7.2 Compile the Target Buildroot Root Filesystem

Compile the actual rootfs with your selected Qt5 and driver configuration:

```bash
cd /home/youyeetoo/buildroot
make
cd /home/youyeetoo

```

_Verification: Confirm `buildroot/output/images/rootfs.ext4` is created._

---

## 8. Packaging `update.img`

### 8.1 Setup Packaging Symlinks

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

### 8.2 Link the Buildroot Rootfs (Prevent Debian Fallback)

Ensure the packaging script points to the newly compiled Buildroot filesystem rather than the Debian image:

```bash
cd /home/youyeetoo/rockdev
rm -f rootfs.ext4 rootfs.img
ln -sf ../buildroot/output/images/rootfs.ext4 ./rootfs.ext4
ln -sf rootfs.ext4 ./rootfs.img
cd /home/youyeetoo

```

### 8.3 Generate Unified Firmware

```bash
./build.sh updateimg

```

_Verification: Confirm `rockdev/update.img` is created and has a size around **800 MB to 1.3 GB** (not 4.0 GB)._

---

## 9. Flashing & Verification (Host Machine)

Execute on your host PC outside the container.

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
3. Flash the generated image:

```bash
cd 6_rk_image/rockdev
sudo rkdeveloptool ld
# sudo rkdeveloptool db MiniLoaderAll.bin    # (Only required if in Maskrom mode)
sudo rkdeveloptool wl 0x0 update.img
sudo rkdeveloptool rd

```

### 9.3 On-Board Validation

After boot (`Welcome to RK356X Buildroot`), verify settings via serial or local terminal:

- **EGLFS Environment:** `env | grep QT_QPA` (Should show `eglfs_kms` and `/etc/kms.conf`).
- **Display Status:** `cat /sys/class/drm/card0-eDP-1/status` (Should read `connected`).
- **GPU & DRM Test:** `kmscube` (A 3D cube should render smoothly on screen).
- **Qt Apps & Rotation:** Run `qplayer` to confirm hardware acceleration and 90° rotation directly on `eDP-1`.
