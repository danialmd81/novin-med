#!/usr/bin/env bash
virt-install \
  --name pi \
  --os-variant linux2020 \
  --arch armv6l \
  --machine versatilepb \
  --cpu arm1176 \
  --vcpus 1 \
  --memory 256 \
  --import \
  --disk ../../../2018-11-13-raspbian-stretch.img,format=raw,bus=virtio \
  --network user,model=virtio \
  --video vga \
  --graphics spice \
  --rng device=/dev/urandom,model=virtio \
  --boot 'dtb=qemu-rpi-kernel/versatile-pb-buster.dtb,kernel=qemu-rpi-kernel/kernel-qemu-4.19.50-buster,kernel_args=root=/dev/vda2 panic=1' \
  --events on_reboot=destroy
