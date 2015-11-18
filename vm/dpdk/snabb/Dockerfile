FROM ubuntu:14.04

MAINTAINER Max Rottenkolber (@eugeneia)

COPY linux-headers-*.deb /root/

RUN dpkg -i /root/linux-headers-*.deb && rm /root/linux-headers-*.deb

RUN apt-get update && apt-get install -y git build-essential screen python pciutils

RUN git clone --depth 1 --branch v2.1.0-snabb https://github.com/eugeneia/dpdk.git /root/dpdk
RUN (cd /root/dpdk; \
     export RTE_KERNELDIR=/lib/modules/$(ls /lib/modules/)/build/; \
     make T=x86_64-native-linuxapp-gcc config -j$(nproc); \
     make T=x86_64-native-linuxapp-gcc install -j$(nproc); \
     make T=x86_64-native-linuxapp-gcc examples -j$(nproc) || true)

RUN echo $'#!/bin/sh\n\
mount -t hugetlbfs nodev /hugetlbfs\n\
echo 64 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages\n\
modprobe uio\n\
insmod /root/dpdk/x86_64-native-linuxapp-gcc/kmod/igb_uio.ko\n\
/root/dpdk/tools/dpdk_nic_bind.py --bind=igb_uio 00:03.0\n\
screen -d -m /root/dpdk/examples/l2fwd/x86_64-native-linuxapp-gcc/l2fwd -c 0x1 -n1 -- -p 0x1\n\
exit 0\n'\
> /etc/rc.local

RUN mkdir /hugetlbfs

RUN cp /etc/init/tty1.conf /etc/init/ttyS0.conf \
    && sed -i '$s/.*/exec \/sbin\/getty -8 115200 ttyS0 linux -a root/' /etc/init/ttyS0.conf \
    && echo vm > /etc/hostname

# Reactivate init, see
# https://github.com/tianon/docker-brew-ubuntu-core/blob/dist/trusty/Dockerfile
RUN rm /usr/sbin/policy-rc.d \
    && rm /sbin/initctl \
    && dpkg-divert --local --rename --remove /sbin/initctl
