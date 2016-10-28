FROM ubuntu:14.04

MAINTAINER Max Rottenkolber (@eugeneia)

COPY modules /lib/modules
RUN depmod $(ls lib/modules/)

RUN apt-get update && apt-get install -y ethtool tcpdump netcat iperf

# fix usr/sbin/tcpdump by moving it into /sbin:
#  error while loading shared libraries: libcrypto.so.1.0.0:
#  cannot open shared object file: Permission denied
RUN mv /usr/sbin/tcpdump /sbin/

RUN cp /etc/init/tty1.conf /etc/init/ttyS0.conf \
    && sed -i '$s/.*/exec \/sbin\/getty -8 115200 ttyS0 linux -a root/' /etc/init/ttyS0.conf \
    && printf "auto eth0\niface eth0 inet manual\ndns-nameserver 8.8.8.8\n" > /etc/network/interfaces \
    && echo vm > /etc/hostname

# Reactivate init, see
# https://github.com/tianon/docker-brew-ubuntu-core/blob/dist/trusty/Dockerfile
RUN rm /usr/sbin/policy-rc.d \
    && rm /sbin/initctl \
    && dpkg-divert --local --rename --remove /sbin/initctl
