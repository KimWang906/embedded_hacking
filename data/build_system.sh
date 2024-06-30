UBOOT_VER="u-boot-2010.03"
LINUX_VER="linux-4.1.6"
DOCKER_CONTAINER_NAME="build_systems"

# Build the bootloader and kernel
docker build -t build_system:latest firmware_build
docker run --name ${DOCKER_CONTAINER_NAME} -d -t build_system:latest

docker cp build_systems:/root/${UBOOT_VER}/u-boot.bin .
docker cp build_systems:/root/${LINUX_VER}/arch/arm/boot/zImage .
docker cp build_systems:/root/kernel.bin .

docker rm -f ${DOCKER_CONTAINER_NAME}

# Build the rootfs
pushd ALL_FILE_SYSTEM
sudo find . | cpio -o --format=newc > ../rootfs.img
gzip -c ../rootfs.img > ../rootfs.img.gz
popd
