# QEMU Raspberry Pi Emulation Script

This directory contains a shell script to launch a QEMU virtual machine emulating a Raspberry Pi environment using an ARMv6 image.

## Script: `start-image.sh`

This script starts a QEMU virtual machine with the following configuration:

- **Machine:** versatilepb (ARMv6)
- **CPU:** arm1176
- **RAM:** 256 MB
- **Disk Image:** `2020-02-13-raspbian-buster.img` (Raspbian Buster)
- **Kernel:** `kernel-qemu-4.19.50-buster`
- **Device Tree:** `versatile-pb-buster.dtb`
- **Network:** User-mode networking with port forwarding (host port 5022 to guest port 22 for SSH)
- **Network Card:** smc91c111 (compatible with versatilepb)

### Usage

```sh
./start-image.sh
```

This will launch the emulated Raspberry Pi. You can SSH into the guest using:

```sh
ssh pi@localhost -p 5022
```

Default credentials for Raspbian are usually:

- Username: `pi`
- Password: `raspberry`

### Requirements

- QEMU installed (`qemu-system-arm`)
- The following files in this directory:
  - `2020-02-13-raspbian-buster.img` (Raspbian image)
  - `kernel-qemu-4.19.50-buster` (kernel for QEMU)
  - `versatile-pb-buster.dtb` (device tree blob)

### Notes

- The script uses user-mode networking. To access the guest via SSH, use the forwarded port as shown above.
- If you need to transfer files, use `scp` or `rsync` with the `-P 5022` or `-e "ssh -p 5022"` option.
- The emulation is for development and testing, not for production workloads.

---
For more information on QEMU and Raspberry Pi emulation, see the [QEMU documentation](https://wiki.qemu.org/Documentation/Platforms/ARM).
