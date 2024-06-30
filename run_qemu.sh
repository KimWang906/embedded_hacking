qemu-system-arm \
    -M versatilepb \
    -m 256M \
    -kernel ./data/zImage \
    -initrd ./data/rootfs.img.gz \
    -append "root=/dev/ram rdinit=/etc/init.d/rcS console=ttyAMA0,115200" \
    -nic user,hostfwd=tcp:0.0.0.0:8080-:80 \
    -nographic

