FROM ubuntu:16.04

MAINTAINER Max Rottenkolber (@eugeneia)

RUN apt-get update && apt-get install -y kmod ethtool tcpdump netcat iperf nmap ipsec-tools

COPY modules /lib/modules
RUN depmod $(ls lib/modules/)

RUN cp /etc/init/tty1.conf /etc/init/ttyS0.conf \
    && sed -i '$s/.*/exec \/sbin\/getty -8 115200 ttyS0 linux -a root/' /etc/init/ttyS0.conf \
    && printf "auto eth0\niface eth0 inet manual\ndns-nameserver 8.8.8.8\n" > /etc/network/interfaces \
    && echo vm > /etc/hostname

# Reactivate init, see
# https://github.com/tianon/docker-brew-ubuntu-core/blob/782f98831e15c270cb19808985dcc28a20ea06de/xenial/Dockerfile#L13
RUN rm /usr/sbin/policy-rc.d \
    && rm /sbin/initctl \
    && dpkg-divert --local --rename --remove /sbin/initctl
