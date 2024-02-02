function parmanode1_fix {

if [[ -d /media/$USER/parmanode1 ]] ; then

sudo umount /media/$USER/parmanode1 && sudo rm -rf /media/$USER/parmanode1


set_terminal ; echo -e "
########################################################################################

    Parmanode has detected a drive mounting glitch, possibley due to previous
    install errors, or you connected a Parmanode drive that hasn't been properly
    'imported' yet. You can go ahead and import the drive from the Parmanode tools
    menu.

########################################################################################
"
enter_continue
fi
}