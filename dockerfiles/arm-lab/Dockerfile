FROM ubuntu:16.04

RUN sed -i "s|//.*archive.ubuntu.com|//mirrors.tuna.tsinghua.edu.cn|" /etc/apt/sources.list && \
    apt update && \
    apt install -y \
        make gcc gcc-arm-linux-gnueabi g++-arm-linux-gnueabi ncurses-dev && \
    apt clean

VOLUME /work

WORKDIR /work
