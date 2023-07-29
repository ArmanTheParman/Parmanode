#accessed by Sparrow and Electrum install

function udev {

if [[ $OS == "Mac" ]] ; then

if [[ $1 == "specter" ]] ; then return 0 ; fi
    set_terminal ; echo "
########################################################################################

    Udev rules are not required for Macs. Skipping.

########################################################################################
    "
    enter_continue
    return 0
    fi


cd /tmp
curl -LO http://parman.org/downloadable/udev
sudo ./udev installudevrules
rm udev
}