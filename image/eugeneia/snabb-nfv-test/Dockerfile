FROM ubuntu:14.04

MAINTAINER Max Rottenkolber (@eugeneia)

RUN apt-get update && apt-get install -y build-essential gcc pkg-config glib-2.0 libglib2.0-dev libsdl1.2-dev libaio-dev libcap-dev libattr1-dev libpixman-1-dev libncurses5 libncurses5-dev git telnet tmux numactl bc

RUN mkdir /hugetlbfs

COPY qemu /root/.test_env/qemu/
COPY *.img /root/.test_env/
COPY bzImage /root/.test_env/

RUN (cd /root/.test_env/qemu/ && make -f Makefile.qemu)
