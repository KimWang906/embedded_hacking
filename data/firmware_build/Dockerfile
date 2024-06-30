FROM ubuntu:16.04

ENV PATH=$PATH:/root/arm-2014.05/bin

WORKDIR /root

COPY u-boot_image.patch .
COPY u-boot_versatile.patch .

# Install dependencies
RUN dpkg --add-architecture i386 && apt update && \
    apt -y install libgtk2.0-0:i386 libxtst6:i386 gtk2-engines-murrine:i386 \
    lib32stdc++6 libxt6:i386 libdbus-glib-1-2:i386 libasound2:i386 unzip gcc \
    build-essential wget lib32ncurses5 lib32ncurses5-dev bc u-boot-tools

# Extract the toolchain
# https://sources.buildroot.net/toolchain-external-codesourcery-arm/
RUN wget https://sources.buildroot.net/toolchain-external-codesourcery-arm/arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 && \
    tar xf arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2

# Build U-Boot
RUN wget ftp://ftp.denx.de/pub/u-boot/u-boot-2010.03.tar.bz2 && \
    tar xf u-boot-2010.03.tar.bz2 && cd u-boot-2010.03 && \
    patch -p1 < /root/u-boot_image.patch && \
    patch -p1 < /root/u-boot_versatile.patch && \
    make versatilepb_config ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- && \
    make all ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- && \
    cp u-boot.bin /root

# Build Linux
RUN wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.1.6.tar.xz && \
    tar xf linux-4.1.6.tar.xz && cd linux-4.1.6 && \
    make ARCH=arm versatile_defconfig && \
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- CONFIG_ARM_EABI=y all && \
    cp arch/arm/boot/zImage /root

WORKDIR /root

# Create the final image
RUN dd if=/dev/zero of=kernel.bin bs=1 count=5M && \
    dd if=u-boot.bin of=kernel.bin conv=notrunc bs=1 && \
    mkimage -A arm -C none -O linux -T kernel -d zImage -a 0x00010000 \
    -e 0x00010000 /root/zImage.uimg && \
    dd if=zImage.uimg of=kernel.bin conv=notrunc bs=1 seek=2M
