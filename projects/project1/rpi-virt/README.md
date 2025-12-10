# Running Raspbian Image with virt-install

This guide explains how to run a Raspbian `.img` file using `virt-install` and QEMU on a Linux host.

## Prerequisites

- QEMU (`qemu-system-arm`)
- libvirt and virt-install
- A Raspbian image (e.g., `2019-09-26-raspbian-buster-lite.img`)
- QEMU-compatible kernel and DTB (e.g., from [qemu-rpi-kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel))

## Example Command

```sh
virt-install \
  --name rpi-vm \
  --arch armv6l \
  --machine versatilepb \
  --cpu arm1176 \
  --vcpus 1 \
  --memory 256 \
  --import \
  --disk /path/to/raspbian.img,format=raw,bus=virtio \
  --network user,model=virtio \
  --video vga \
  --graphics spice \
  --rng device=/dev/urandom,model=virtio \
  --boot 'dtb=/path/to/versatile-pb-buster.dtb,kernel=/path/to/kernel-qemu-4.19.50-buster,kernel_args=root=/dev/vda2 panic=1' \
  --events on_reboot=destroy \
  --os-variant linux2020
```

## Notes

- Replace `/path/to/raspbian.img`, `/path/to/versatile-pb-buster.dtb`, and `/path/to/kernel-qemu-4.19.50-buster` with your actual file paths.
- The `--os-variant linux2020` option is required for recent virt-install versions.
- The `versatilepb` machine type supports a maximum of 256MB RAM.
- For desktop environments, use a full Raspbian image (not Lite), but graphical support is limited in emulation.

## Troubleshooting

- If you see errors about unsupported disk bus or network device, try changing the bus/model to `virtio`, `rtl8139`, or `pcnet`.
- For SSH access, set up port forwarding or use bridge networking.
- For more RAM or better emulation, consider using QEMU's `raspi2` or `raspi3` machine type (requires aarch64 kernel and image).

## References

- [qemu-rpi-kernel](https://github.com/dhruvvyas90/qemu-rpi-kernel)
- [Raspberry Pi OS Images](https://www.raspberrypi.org/software/operating-systems/)
