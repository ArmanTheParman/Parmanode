function safe_unmount_parmanode {
if ! mount | grep parmanode ; then
return 0
fi

source $HOME/.parmanode/parmanode.conf

if [[ $drive == external ]] ; then
stop_bitcoind
fi
if [[ $drive_fulcrum == external ]] ; then
stop_fulcrum_linux
fi
if [[ $drive_electrs == external ]] ; then
stop_electrs
fi

# unmount after everything stopped.
sudo umount /media/$USER/parmanode

if mount | grep parmanode ; then
echo -e "

Unable to unmount Parmanode drive. Aborting.

Hit$cyan <enter>$orange to continue.
"
read
return 1
else
return 0
fi

}