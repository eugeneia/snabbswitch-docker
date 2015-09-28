### Building the default test environment

This repository hosts scripts used to produce the test environments used
by Snabb Switch. To build the `eugeneia/snabb-nfv-test` Docker image you
need to fetch the git submodules and run `make image`:

```
git submodule update --init
make image
```

This will build the default versions of all test assets (which can be
found under `assets/`) and a Docker image `eugeneia/snabb-nfv-test`
containing these. To install the built assets to your local
`~/.test_env/` installation you need to run:

```
make install
```


### Building a custom test environment

The Makefile exposes a bunch of environment variables that can be
modified to produce custom builds of the test environment. The defined
variables are:

* `NFV_QEMU` (defaults to “SnabbCo”): The contents of this variable
  indicate the QEMU version to bundle. The available QEMU versions can be
  found under `qemu/`, where each subdirectory must contain a git
  submodule `qemu` pointing to a revision, and a `Makefile` that
  specifies how that revision is built.

* `NFV_GUEST_KERNEL` (defaults to “ubuntu-trusty”): The contents of this
  variable indicate the Linux kernel version to bundle. The available
  kernel versions can be found under `kernel/`, where each subdirectory must
  contain a git submodule pointing to a kernel source revision, and a
  `Makefile` that specifies how that revision is built.

* `NFV_GUEST_OS` (defaults to “ubuntu”), `NFV_GUEST_VERSION` (defaults to
  “14.04”): The contents of these variables indicate the VM images to
  bundle. The available guest VMs can be found under
  `vm/$NFV_GUEST_OS/$NFV_GUEST_VERSION`. Each guest VM is defined by a
  Dockerfile.

* `NFV_DPDK_VERSION` (defaults to “vosys”): The contents of this variable
  indicate the DPDK version to use is the DPDK/l2fwd guest bundled. See
  `vm/dpdk/$NFV_DPDK_VERSION/Dockerfile`.

* `IMAGE` (defaults to “eugeneia/snabb-nfv-test”): The contents of this
  variable indicate what kind of Docker image to bundle the assets
  in. See `image/$IMAGE/Dockerfile`.

If, for example, you want to build an alternate a test environment for
Snabb Switch called “example/alternate” you would specify your image in
`image/example/alternate/Dockerfile` and build it as follows:

```
make IMAGE=example/alternate image
```
