#!/bin/bash

set -e

NFV_GUEST_OS=$1
NFV_GUEST_VERSION=$2
NFV_GUEST_IMAGE=vm-$NFV_GUEST_OS-$NFV_GUEST_VERSION

cp vm/$NFV_GUEST_OS/$NFV_GUEST_VERSION/Dockerfile context/
docker build -t $NFV_GUEST_IMAGE context/
docker create --name=$NFV_GUEST_IMAGE $NFV_GUEST_IMAGE
dd if=/dev/zero of=assets/qemu.img bs=1 count=0 seek=1G
mkfs.ext2 -F assets/qemu.img
mkdir $NFV_GUEST_IMAGE
sudo mount -o loop assets/qemu.img $NFV_GUEST_IMAGE
docker export $NFV_GUEST_IMAGE | sudo tar x -C $NFV_GUEST_IMAGE
sudo umount $NFV_GUEST_IMAGE
rmdir $NFV_GUEST_IMAGE
docker rm $NFV_GUEST_IMAGE
