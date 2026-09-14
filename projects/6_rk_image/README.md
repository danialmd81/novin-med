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

## 1. Container Setup on Host (Podman)

Run these commands on your Linux host machine to import and launch the SDK container environment.

### 1.1 Import the Container Image

Imports the provided build environment archive into your local container storage.

```bash
podman import YY3568-Debian10.tar.gz rk3568-builder:latest


### 1.2 Start the Build Container

Launches the container matching your host user ID/GID, keeping directory ownership intact while mounting the SDK workspace (`6_rk_image`) to `/home/youyeetoo`.

```bash
podman run -it \
  --name rk_builder \
  --user $(id -u):$(id -g) \
  --userns=keep-id \
  -v $(pwd)/6_rk_image:/home/youyeetoo:Z \
  -w /home/youyeetoo \
  rk3568-builder:latest /bin/bash

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

*(Select the option corresponding to `YY3568-Buildroot.mk`, typically `10`).*

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
- `display platform (gbm) --->` *(Must be **`gbm`**, NOT `wayland`)*

- `[*] Rockchip RGA lib for linux` *(2D hardware blitter/rotator engine)*
- `[*] MPP(Multimedia Processing Platform)`
- `[*] rkwifibt`

- **Graphic Engine & Qt5 (`Target packages ---> Graphic libraries and applications --->`)**
- `[*] kmscube` *(DRM/KMS hardware rendering test app)*
- `[ ] weston` *(Must be unchecked to prevent DRM device conflicts)*
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
- `[*] qt5tools` *(Provides `qtdiag`, `qtpaths`)*

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

## 6. Build the Firmware

Compiles the bootloader, kernel, Buildroot rootfs, and bundles them into partition images.

### 6.1 Run Main Compilation

```bash
./build.sh 2>&1 | tee build.log

```

---

## 7. Packaging `update.img`

Fixes the Rockchip packaging link dependencies and builds the unified flashable file.

### 7.1 Setup Packaging Symlinks

Creates links to the chip-specific packaging script and package-file description:

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

### 7.2 Generate Unified Firmware

```bash
cd /home/youyeetoo
./build.sh updateimg

```

*Verification: Confirm `rockdev/update.img` is created.*

---

## 8. Flashing & Verification (Host Machine)

Execute on your host PC outside the container.

### 8.1 Install `rkdeveloptool`

```bash
sudo apt update
sudo apt install -y libusb-1.0-0-dev libudev-dev pkg-config git build-essential cmake
git clone [https://github.com/rockchip-linux/rkdeveloptool.git](https://github.com/rockchip-linux/rkdeveloptool.git)
cd rkdeveloptool && cmake -B build && cmake --build build
sudo cp build/rkdeveloptool /usr/local/bin/

```

### 8.2 Flash Firmware

1. Connect the YY3568 USB Type-C OTG port to your PC.
2. Hold **Recovery**, press **Reset**, wait 3 seconds, and release.
3. Flash the generated image:

```bash
cd 6_rk_image/rockdev
sudo rkdeveloptool ld
sudo rkdeveloptool db MiniLoaderAll.bin    # (Only required if in Maskrom mode)
sudo rkdeveloptool wl 0x0 update.img
sudo rkdeveloptool rd

```

### 8.3 On-Board Validation

After boot, run the following commands on the board terminal:

- **Display Status:** `cat /sys/class/drm/card0-eDP-1/status` (Should read `connected`).
- **GPU & DRM Test:** `kmscube` (A 3D cube should render on the screen).
- **Qt Configuration:** `qtdiag` (Should show `eglfs_kms` active with `eDP-1` configured).
