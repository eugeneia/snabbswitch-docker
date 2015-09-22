FROM ubuntu:14.04

MAINTAINER Max Rottenkolber (@eugeneia)

RUN apt-get update && apt-get install -y build-essential qemu git telnet tmux numactl bc

RUN mkdir /hugetlbfs

COPY qemu /root/.test_env/qemu/
COPY *.img /root/.test_env/
COPY bzImage /root/.test_env/
