NPROC=$(shell nproc)
VERSION=$(shell (cd ubuntu-trusty; make kernelversion))

all: ubuntu-trusty/.config ubuntu-trusty/arch/x86/boot/bzImage modules linux-headers-*.deb

ubuntu-trusty/.config:
	@ (cd ubuntu-trusty; \
	   cat debian.master/config/config.common.ubuntu \
	       debian.master/config/amd64/config.common.amd64 \
	       debian.master/config/amd64/config.flavour.generic > .config; \
	   echo CONFIG_VIRTIO_NET=m >> .config; \
	   echo CONFIG_UIO=y >> .config; \
	   echo CONFIG_DEBUG_INFO=n >> .config)

ubuntu-trusty/arch/x86/boot/bzImage:
	@ (cd ubuntu-trusty; make bzImage -j$(NPROC))

modules:
	@ (cd ubuntu-trusty; make M=drivers/net virtio_net.ko -j$(NPROC))
	@ (mkdir -p modules/$(VERSION))
	@ (cp ubuntu-trusty/drivers/net/virtio_net.ko modules/$(VERSION)/)

linux-headers-*.deb:
	@ (cd ubuntu-trusty; make deb-pkg -j$(NPROC))

clean:
	@ (cd ubuntu-trusty; make clean)
	@-rm -rf modules *.deb

.PHONY: clean
