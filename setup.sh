read -p "Root password: " rootPassword
read -p "Share IP: " shareIP
setup-alpine << EOF
be
be
tvpi
eth0
dhcp
done
no
$rootPassword
$rootPassword
UTC
none
chrony
1
openssh
none
none
EOF
apk add e2fsprogs
mkfs.ext4 /dev/mmcblk0p2 << EOF
y
EOF
mkdir /stage
mount /dev/mmcblk0p2 /stage
setup-disk -m sys /stage
echo /dev/mmcblk0p1 /media/mmcblk0p1 vfat defaults,ro 0 0 >> /stage/etc/fstab
mount -o remount,rw /media/mmcblk0p1
sed -i "s/SHARE_IP/$shareIP/" /media/mmcblk0p1/setup2.sh
sed -i '/include usercfg.txt/d' /media/mmcblk0p1/config.txt
sed -i '/arm_control=0x200/d' /media/mmcblk0p1/config.txt
sed -i '/arm_64bit=1/d' /media/mmcblk0p1/config.txt
echo arm_64bit=1 >> /media/mmcblk0p1/config.txt
sed -i '/disable_overscan=1/d' /media/mmcblk0p1/config.txt
echo disable_overscan=1 >> /media/mmcblk0p1/config.txt
sed -i '/dtoverlay=vc4-kms-v3d/d' /media/mmcblk0p1/config.txt
echo dtoverlay=vc4-kms-v3d >> /media/mmcblk0p1/config.txt
sed -i '/gpu_mem=128/d' /media/mmcblk0p1/config.txt
echo gpu_mem=128 >> /media/mmcblk0p1/config.txt
sed -i '/logo.nologo/d' /media/mmcblk0p1/cmdline.txt
sed -i '/root=\/dev\/mmcblk0p2/d' /media/mmcblk0p1/cmdline.txt
sed -i '$ s/$/ logo.nologo root=\/dev\/mmcblk0p2/' /media/mmcblk0p1/cmdline.txt
echo /media/mmcblk0p1/boot /boot none defaults,bind 0 0 >> /etc/fstab
echo @reboot /media/mmcblk0p1/setup2.sh >> /stage/etc/crontabs/root
chmod +x /media/mmcblk0p1/setup2.sh
reboot