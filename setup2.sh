sed -i '/@reboot \/media\/mmcblk0p1\/setup2.sh/d' /etc/crontabs/root
echo PermitRootLogin yes >> /etc/ssh/sshd_config
sed -i '/	udhcpc_opts -t 20/d' /etc/network/interfaces
echo '	udhcpc_opts -t 20' >> /etc/network/interfaces
sed -i '/0	3	*	*	*	poweroff/d' /etc/crontabs/root
echo '0	3	*	*	*	poweroff' >> /etc/crontabs/root
sed -i '3s/\#//' /etc/apk/repositories
apk update
apk upgrade
setup-xorg-base
apk add xf86-video-fbdev
apk add mesa-dri-vc4
apk add libreoffice
apk add cifs-utils
rm -rf /var/cache/apk/*
adduser -D user
ln -s /media/mmcblk0p1/fonts /home/user/.fonts
mkdir /share
chmod +r /share
mount -o remount,rw /media/mmcblk0p1
sed -i '$ s/$/ overlaytmpfs=yes/' /media/mmcblk0p1/cmdline.txt
echo @reboot mount //SHARE_IP/TVPI /share -o user=TVPI,password=TVPI >> /etc/crontabs/root
echo exec /media/mmcblk0p1/startShow.sh >> /home/user/.xinitrc
echo @reboot startx -- -nocursor >> /etc/crontabs/user
reboot