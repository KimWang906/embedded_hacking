FROM ubuntu:18.04

ENV TZ=Asia/Seoul
ENV LC_CTYPE=C.UTF-8
ENV PGPASSWORD=firmadyne
ENV SCHEMA_FIRMADYNE=/root/firmware-analysis-plus/firmadyne/database/schema
ENV USER=root

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
WORKDIR /root

RUN apt update && DEBIAN_FRONTEND=noninteractive \
    apt -y install busybox-static fakeroot git dmsetup \
    kpartx netcat-openbsd nmap python-psycopg2 python3-psycopg2 \
    snmp uml-utilities util-linux vlan wget postgresql build-essential \
    vim python3-pip sudo libjpeg8-dev qemu-system-mipsel

RUN echo "root:1234" | chpasswd

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN git clone https://github.com/liyansong2018/firmware-analysis-plus.git && \
    cd firmware-analysis-plus && ./setup.sh && cd firmadyne && ./download.sh

# Set FIRMWARE_DIR in firmadyne.config
# WORKDIR /root/firmware-analysis-toolkit/firmadyne/
# RUN sed -i 's|#FIRMWARE_DIR=/home/vagrant/firmadyne/|FIRMWARE_DIR=/root/firmware-analysis-toolkit/firmadyne/|' firmadyne.config

WORKDIR /root/firmware-analysis-plus
RUN sed -i 's|sudo_password=kali|sudo_password=1234|' fap.config && \
    sed -i 's|firmadyne_path=/home/attify/firmware-analysis-toolkit/firmadyne|firmadyne_path=/root/firmware-analysis-toolkit/firmadyne|' \
    fap.config

RUN service postgresql start && \
    sudo -u postgres createuser firmadyne && \
    sudo -u postgres createdb -O firmadyne firmware && \
    sudo -u postgres psql -d firmware < ./firmadyne/database/schema && \
    echo "ALTER USER firmadyne PASSWORD 'firmadyne'" | sudo -u postgres psql

WORKDIR /root/hardware_analysis
ENTRYPOINT ["bash", "-c", "psql \
-h firmadyne_db \
-p 5432 \
-U firmadyne \
-d firmware < $SCHEMA_FIRMADYNE && \
tail -f /dev/null"]
