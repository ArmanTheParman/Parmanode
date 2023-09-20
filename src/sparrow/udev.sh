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

if [[ $chip == "x86_64" ]] ; then
cd /tmp
curl -LO http://parman.org/downloadable/udev
sudo chmod +x /tmp/udev
sudo ./udev installudevrules
fi

if [[ $chip == "aarch64" ]] ; then
cd /tmp
curl -LO http://parman.org/downloadable/udev_aarch64
sudo chmod +x /tmp/udev_arch64
sudo ./udev_arch64 installudevrules
fi


}