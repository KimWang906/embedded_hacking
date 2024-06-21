FROM ubuntu:22.04

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

RUN dpkg --add-architecture i386 && \
    apt update && apt -y install \
    wget build-essential libgtk2.0-0:i386 \
    libxtst6:i386 \
    lib32stdc++6 libxt6:i386 libdbus-glib-1-2:i386 \
    libasound2:i386 unzip

WORKDIR /opt
RUN wget https://sources.buildroot.net/toolchain-external-codesourcery-arm/arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2 && \
    tar xvf arm-2014.05-29-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
ENV PATH=$PATH:/opt/arm-2014.05/bin

WORKDIR /root/hardware_analysis

ENTRYPOINT ["bash", "-c", "tail -f /dev/null"]