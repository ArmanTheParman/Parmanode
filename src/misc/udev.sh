function udev {

#Udev rules are not required for Macs.
if [[ $OS == "Mac" ]] ; then return 0 ; fi
clear
echo -e "Importing UDEV rules for hardware wallet connections..."
please_wait noclear

if [[ $chip == "x86_64" ]] ; then
cd $tmp
curl -LO http://parman.org/downloadable/udev
sudo chmod +x $tmp/udev
sudo ./udev installudevrules
fi

if [[ $chip == "aarch64" ]] ; then
cd $tmp
curl -LO http://parman.org/downloadable/udev_aarch64
sudo chmod +x $tmp/udev_aarch64
sudo ./udev_aarch64 installudevrules
fi




installed_conf_add "udev-end"
success "UDEV rules for easy HWW connections" "being imported"

}



echo "
sudo install -m 644 /home/parman/parmanode/Sparrow/lib/runtime/conf/udev/*.rules /etc/udev/rules.d
sudo udevadm control --reload
sudo udevadm trigger
sudo groupadd -f plugdev
sudo usermod -aG plugdev `whoami`
" >/dev/null