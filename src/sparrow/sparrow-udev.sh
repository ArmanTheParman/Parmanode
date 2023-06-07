function sparrow_udev {

if [[ $OS == "Mac" ]] ; then
    set_terminal ; echo "
########################################################################################

    Udev rules are not required for Macs. Skipping.

########################################################################################
    "
    enter_continue
    return 0
    fi


cd $HOME/parmanode/Sparrow
curl -LO http://parman.org/downloadable/sparrow-udev
sudo ./sparrow-udev installudevrules
rm sparrow-udev
success "The udev rules" "being installed"

}