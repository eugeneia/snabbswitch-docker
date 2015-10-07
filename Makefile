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
IMAGE=eugeneia/snabb-nfv-test

all: assets/qemu assets/bzImage assets/qemu.img image

assets:
	$(E) "MKDIR	assets"
	$(Q) (mkdir -p assets)

context:
	$(E) "MKDIR	context"
	$(Q) (mkdir -p context)

assets/qemu: assets
	$(E) "COPY	QEMU $(NFV_QEMU)"
	$(Q) (cp -r qemu/$(NFV_QEMU)/qemu assets/qemu)
	$(Q) (cp -r qemu/$(NFV_QEMU)/Makefile assets/qemu/Makefile.qemu)

assets/bzImage: assets context
	$(E) "COMPILE	Linux $(NFV_GUEST_KERNEL)"
	$(Q) (docker run -i -v $(shell pwd)/kernel/$(NFV_GUEST_KERNEL):/kernel eugeneia/kernel-build-env \
		bash -c "(cd /kernel && make)")
	$(Q) (cp kernel/$(NFV_GUEST_KERNEL)/$(NFV_GUEST_KERNEL)/arch/x86/boot/bzImage assets/bzImage)
	$(Q) (cp -r kernel/$(NFV_GUEST_KERNEL)/modules context/)
	$(Q) (cp kernel/$(NFV_GUEST_KERNEL)/linux-headers-*.deb context/)

assets/qemu.img: assets/bzImage
	$(E) "CREATE	Guest $(NFV_GUEST_OS) $(NFV_GUEST_VERSION)"
	$(Q) (scripts/docker-img.sh $(NFV_GUEST_OS) $(NFV_GUEST_VERSION) assets/qemu.img)

assets/qemu-dpdk.img: assets/bzImage
	$(E) "CREATE	Guest DPDK $(NFV_DPDK_VERSION)"
	$(Q) (scripts/docker-img.sh dpdk $(NFV_DPDK_VERSION) assets/qemu-dpdk.img)

image: assets/qemu assets/bzImage assets/qemu.img assets/qemu-dpdk.img
	$(E) "DOCKER BUILD	$(IMAGE)"
	$(Q) (cp image/$(IMAGE)/Dockerfile assets/ && docker build -t $(IMAGE) assets/)

install: assets/qemu assets/bzImage assets/qemu.img assets/qemu-dpdk.img
	$(E) "INSTALL	assets/* => ~/.test_env/"
	$(Q) (mkdir -p ~/.test_env/)
	$(Q) (cp -r assets/* ~/.test_env/)
	$(Q) (cd ~/.test_env/qemu && make -f Makefile.qemu)

kernel-build-env:
	docker build -t eugeneia/kernel-build-env kernel/build_env/

clean:
	$(E) "RM        assets context"
	$(Q)-rm -rf assets context

.PHONY: clean image context assets kernel-build-env
