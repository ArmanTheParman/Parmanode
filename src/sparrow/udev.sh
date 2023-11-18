#accessed by Sparrow and Electrum install

function udev {

if [[ $OS == "Mac" ]] ; then

    set_terminal ; echo "
    ########################################################################################

        Udev rules are not required for Macs. Skipping.

    ########################################################################################
    "
    enter_continue
    return 0
fi

set_terminal
echo "Importing UDEV rules for hardware wallet connections..."
please_wait

if [[ $chip == "x86_64" ]] ; then
cd /tmp
curl -LO http://parman.org/downloadable/udev
sudo chmod +x /tmp/udev
sudo ./udev installudevrules
success "UDEV rules for easy HWW connections" "being imported"
fi

if [[ $chip == "aarch64" ]] ; then
cd /tmp
curl -LO http://parman.org/downloadable/udev_aarch64
sudo chmod +x /tmp/udev_aarch64
sudo ./udev_aarch64 installudevrules

success "UDEV rules for easy HWW connections" "being imported"


installed_conf_add "udev-end"

fi
}