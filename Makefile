Q= @
E= @echo
# For verbose command line output, uncomment these lines:
#Q=
#E= @:

NFV_QEMU=SnabbCo
NFV_GUEST_KERNEL=ubuntu-trusty
NFV_GUEST_OS=ubuntu
NFV_GUEST_VERSION=14.04
NFV_DPDK_VERSION=vosys

all: assets/qemu assets/bzImage assets/qemu.img

assets:
	$(E) "MKDIR	assets"
	$(Q) (mkdir -p assets)

context:
	$(E) "MKDIR	context"
	$(Q) (mkdir -p context)

assets/qemu: assets
	$(E) "COMPILE	QEMU $(NFV_QEMU)"
	$(Q) (cd qemu/$(NFV_QEMU); make)
	$(Q) (cp -r qemu/$(NFV_QEMU)/qemu assets/qemu)

assets/bzImage: assets context
	$(E) "COMPILE	Linux $(NFV_GUEST_KERNEL)"
	$(Q) (cd kernel/$(NFV_GUEST_KERNEL); make)
	$(Q) (cp kernel/$(NFV_GUEST_KERNEL)/$(NFV_GUEST_KERNEL)/arch/x86/boot/bzImage assets/bzImage)
	$(Q) (cp -r kernel/$(NFV_GUEST_KERNEL)/modules context/)
	$(Q) (cp kernel/$(NFV_GUEST_KERNEL)/linux-headers-*.deb context/)

assets/qemu.img: assets/bzImage
	$(E) "CREATE	Guest $(NFV_GUEST_OS) $(NFV_GUEST_VERSION)"
	$(Q) (./docker-img.sh $(NFV_GUEST_OS) $(NFV_GUEST_VERSION) assets/qemu.img)

assets/qemu-dpdk.img: assets/bzImage
	$(E) "CREATE	Guest DPDK $(NFV_DPDK_VERSION)"
	$(Q) (./docker-img.sh dpdk $(NFV_DPDK_VERSION) assets/qemu-dpdk.img)

clean:
	$(E) "RM        assets context"
	$(Q)-rm -rf assets context

.PHONY: clean
