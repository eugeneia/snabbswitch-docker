FROM ubuntu:14.04

MAINTAINER Max Rottenkolber (@eugeneia)

RUN apt-get update && apt-get install -y wget build-essential gcc pkg-config glib-2.0 libglib2.0-dev libsdl1.2-dev libaio-dev libcap-dev libattr1-dev libpixman-1-dev libncurses5 libncurses5-dev git telnet tmux numactl bc

RUN wget http://www.openonload.org/download/openonload-201502.tgz \
    && tar xf openonload-201502.tgz \
    && (cd openonload-201502/ && scripts/onload_build --user64; cp build/gnu_x86_64/lib/ciul/libciul.so* /usr/lib/) \
    && rm -r openonload-201502*

RUN mkdir /hugetlbfs

COPY qemu /root/.test_env/qemu/
COPY *.img /root/.test_env/
COPY bzImage /root/.test_env/

RUN (cd /root/.test_env/qemu/ && make -f Makefile.qemu)
