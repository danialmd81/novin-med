#!/usr/bin/env bash
qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-drive file=/home/danial/Code/novin-med/projects/project1/2020-02-13-raspbian-buster.img,format=raw \
	-net nic,model=smc91c111 \
	-net user,hostfwd=tcp::5022-:22 \
	-dtb versatile-pb-buster.dtb \
	-kernel kernel-qemu-4.19.50-buster \
	-append 'root=/dev/sda2 panic=1'
