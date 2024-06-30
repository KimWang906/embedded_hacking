qemu-system-arm \
    -M versatilepb \
    -m 256M \
    -kernel ./zImage \
    -initrd ./rootfs.img.gz \
    -append "root=/dev/ram rdinit=/etc/init.d/rcS console=ttyAMA0,115200" \
    -nic user,hostfwd=tcp:127.0.0.1:8080-:80,hostfwd=tcp:127.0.0.1:7777-:7777,hostfwd=tcp:127.0.0.1:2323-:23 \
    -nographic
