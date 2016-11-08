obj:
	@ mkdir obj
	@ pwd 1>&2
	@ ls -l 1>&2
	@ ls -l obj 1>&2
	@ (cd obj; ../configure --target-list=x86_64-softmmu && make -j$(shell nproc))
