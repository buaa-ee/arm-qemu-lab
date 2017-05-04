top     :=  $(shell pwd)
dtb     :=  build/linux-4.10.5/arch/arm/boot/dts/vexpress-v2p-ca9.dtb
kernel  :=  build/linux-4.10.5/arch/arm/boot/zImage
rootfs  :=  build/rootfs
hello   :=  $(rootfs)/hello
sd      :=  build/rootfs.ext3

docker_run  := docker run --rm -it -v `pwd`:/work
armcc       := $(docker_run) arm-lab arm-linux-gnueabi-gcc

.PHONY: all hello run

all: run.sd.nographic

run.nfs: $(dtb) $(kernel) $(rootfs) hello
	@echo starting QEMU with graphic, using NFS as root
	@qemu-system-arm -M vexpress-a9 \
		-dtb $(dtb) \
		-kernel $(kernel) \
		-append "root=/dev/nfs console=tty0 nfsroot=10.0.2.2:/$(top)/rootfs rw ip=dhcp"

run.sd: $(dtb) $(kernel) $(sd)
	@echo starting QEMU with graphic, using SD image as root
	@qemu-system-arm -M vexpress-a9 \
		-dtb $(dtb) \
		-kernel $(kernel) \
		-drive if=sd,index=0,file=$(sd),format=raw \
		-append "root=/dev/mmcblk0 console=tty0"

run.nfs.nographic: $(dtb) $(kernel) $(rootfs) hello
	@echo starting QEMU without graphic, using NFS as root
	@qemu-system-arm -M vexpress-a9 \
		-dtb $(dtb) \
		-kernel $(kernel) \
		-append "root=/dev/nfs console=ttyAMA0 nfsroot=10.0.2.2:/$(top)/$(rootfs) rw ip=dhcp" \
		-nographic

run.sd.nographic: $(dtb) $(kernel) $(sd)
	@echo starting QEMU with graphic, using SD image as root
	@qemu-system-arm -M vexpress-a9 \
		-dtb $(dtb) \
		-kernel $(kernel) \
		-drive if=sd,index=0,file=$(sd),format=raw \
		-append "root=/dev/mmcblk0 console=ttyAMA0" \
		-nographic

hello: $(hello)

$(hello): src/hello.c
	@echo building $@ in docker
	@$(armcc) $< -o $@
