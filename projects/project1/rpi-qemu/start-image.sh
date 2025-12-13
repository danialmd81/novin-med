#!/usr/bin/env bash
qemu-system-arm \
	-M versatilepb \
	-cpu arm1176 \
	-m 256 \
	-drive file=/home/danial/Code/svn/trunk/OS/Images/2018-11-13-raspbian-stretch.img,format=raw \
	-net nic,model=smc91c111 \
	-net user,hostfwd=tcp::5022-:22 \
	-dtb versatile-pb.dtb \
	-kernel kernel-qemu-4.14.79-stretch \
	-append 'root=/dev/sda2 panic=1'
