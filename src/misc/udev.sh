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

udev_patch

installed_conf_add "udev-end"

success "UDEV rules for easy HWW connections have been imported.
    This is a necessary fiddly step to make hardware wallets work
    on Linux."

}


function udev_patch {
if [[ $OS == "Mac" ]] ; then return 0 ; fi
sudo install -m 644 $pn/src/misc/udev/*.rules /etc/udev/rules.d >$dn
sudo udevadm control --reload >$dn
sudo udevadm trigger >$dn
sudo groupadd -f plugdev >$dn
sudo usermod -aG plugdev $(USER) >$dn
}