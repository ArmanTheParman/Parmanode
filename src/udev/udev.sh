function udev {

#Udev rules are not required for Macs.
if [[ $OS == "Mac" ]] ; then return 0 ; fi

sudo install -m 644 $pn/src/udev/*.rules /etc/udev/rules.d >$dn 2>&1
sudo udevadm control --reload >$dn
sudo udevadm trigger >$dn
sudo groupadd -f plugdev >$dn
sudo usermod -aG plugdev `whoami` >$dn

installed_conf_add "udev-end"

success "UDEV rules for easy HWW connections have been imported.
    This is a necessary fiddly step to make hardware wallets work
    on Linux."
}

