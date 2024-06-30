FROM ubuntu:16.04

ENV PATH=$PATH:/root/arm-2014.05/bin
ENV CC=/root/arm-2014.05/bin/arm-none-linux-gnueabi-gcc
ENV STRIP=/root/arm-2014.05/bin/arm-none-linux-gnueabi-strip

WORKDIR /root

# Install dependencies
RUN dpkg --add-architecture i386 && apt update && \
    apt -y install libgtk2.0-0:i386 libxtst6:i386 gtk2-engines-murrine:i386 \
    lib32stdc++6 libxt6:i386 libdbus-glib-1-2:i386 libasound2:i386 unzip gcc \
    build-essential wget lib32ncurses5 lib32ncurses5-dev bc u-boot-tools texinfo \
    rsync python cpio

# Set up the arm-2014.05 toolchain
# https://sources.buildroot.net/toolchain-external-codesourcery-arm/
RUN wget https://sources.buildroot.net/toolchain-external-codesourcery-arm/arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 && \
    tar xf arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2

# RUN wget https://github.com/strace/strace/releases/download/v4.15/strace-4.15.tar.xz && \
#     tar xf strace-4.15.tar.xz && cd strace-4.15 && \
#     ./configure --host=arm-none-linux-gnueabi CFLAGS=-static && \
#     make && cp strace /root

WORKDIR /root

ENV CC=/root/cross-compiler-armv4l/bin/armv4l-gcc
ENV STRIP=/root/cross-compiler-armv4l/bin/armv4l-strip

COPY gdb_configure.patch .
# # Set up the armv4l toolchain
COPY cross-compiler-armv4l.tar.bz2 .
RUN tar xf cross-compiler-armv4l.tar.bz2 && \
    ln -s /root/cross-compiler-armv4l/bin/armv4l-ar /bin/arm-linux-ar

# # Set up the termcap library
RUN wget https://ftp.gnu.org/gnu/termcap/termcap-1.3.1.tar.gz && \
    tar xf termcap-1.3.1.tar.gz && cd termcap-1.3.1 && \
    ./configure --host=arm-linux && make && cp libtermcap.a /root

# # Build gdb
RUN wget https://ftp.gnu.org/gnu/gdb/gdb-6.8a.tar.gz && \
    tar xf gdb-6.8a.tar.gz && cd gdb-6.8 && \
    patch -p1 < /root/gdb_configure.patch && \
    ./configure --host=arm-linux CFLAGS=-static && make && \
    cp gdb/gdb /root && cp gdb/gdbserver/gdbserver /root

# Build ltrace, strace
RUN wget http://buildroot.uclibc.org/downloads/buildroot-2013.08.1.tar.gz && \
    tar xf buildroot-2013.08.1.tar.gz
COPY .buildroot_config /root/buildroot-2013.08.1/.config
RUN cd buildroot-2013.08.1 && make && \
    cp ./output/target/usr/bin/ltrace /root && \
    cp ./output/target/usr/bin/strace /root
