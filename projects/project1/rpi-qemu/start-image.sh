#!/usr/bin/env bash
qemu-system-arm \
  -M versatilepb \
  -cpu arm1176 \
  -m 256 \
  -drive file=../../../2018-11-13-raspbian-stretch.img,format=raw \
  -net user,hostfwd=tcp::5022-:22 \
  -dtb versatile-pb-buster.dtb \
  -kernel kernel-qemu-4.19.50-buster \
  -append 'root=/dev/sda2 panic=1' \
  -device rtl8139
