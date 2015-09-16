qemu/obj: qemu
	@ mkdir qemu/obj
	@ (cd qemu/obj; ../configure --target-list=x86_64-softmmu && make -j`nproc`)

clean:
	@-rm -rf qemu/obj

all: qemu/obj

.PHONY: clean
