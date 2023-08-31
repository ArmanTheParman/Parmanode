#accessed by Sparrow and Electrum install

function udev {
debug "in udev and arg1 is $1"
log "sparrow" "in udev function"

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
debug "downloading udev rules..."
curl -LO http://parman.org/downloadable/udev
sudo ./udev installudevrules
debug "finished downloading and installing udev rules; next rm udev"
rm udev
}