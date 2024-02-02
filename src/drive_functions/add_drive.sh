function add_drive {
########################################################################################
#not complete; adding potential arguments passed to add_drive:
   # make_label=parmanode (environment)

########################################################################################

info_add_drive $@ || return 1 # safe unmount executed

set_terminal ; echo -e "
########################################################################################
$cyan
                      Automatic drive detection procedure ...
$orange
    Please make sure the drive you want to bring in is$pink PHYSICALLY DISCONNECTED$orange, 
    i.e. detach the cable, before proceeding or you could get errors. 

########################################################################################
$orange" ; enter_continue

safe_unmount_parmanode || return 1

if [[ ! $wasntmounted == true ]] ; then
set_terminal ; echo -e "$cyan
########################################################################################
   Parmanode has safely unmounted your$green regular$cyan Parmanode drive by stopping 
   the programs using it, then unmounting. PLEASE PHYSICALLY DISCONNECT THE DRIVE 
   NOW, ie detach the cable.
########################################################################################
" ; enter_continue ; set_terminal
fi

detect_drive $@ "brief" || return 1 #menu
#drive should be mounted at this point.

if [[ $OS == "Mac" ]] ; then
    set_terminal
    echo "
########################################################################################

    The drive should be ready. If it is not mounted, disconnect and reconnect.

########################################################################################
"
enter_continue ; return 0 ;
fi

if [[ $OS == "Linux" ]] ; then make_linux_parmanode_drive ; return 0 ; fi

}

function make_linux_parmanode_drive {

if [[ $OS != Linux ]] ; then return 1 ; fi

########################################################################################

#drive should be mounted
#$disk variable should be in environment, format /dev/xxxn  ie with or without a number, n.
#Function called by add drive
#environment label $make_label expected

debug "test disk variable into make_linux_parmanode_drive, is...
    $disk
    If there is a partition number, that should not be removed
    should be in the format /dev/diskn

    "
########################################################################################

if [[ $make_label == "parmanode" ]] ; then
        sudo umount $disk* 2>/dev/null ; sudo umount $parmanode_drive 2>/dev/null
        sudo umount /media/$USER/parmanod* 2>/dev/null
        sudo e2label $disk parmanode >/dev/null || sudo exfatlabel $disk parmanode >/dev/null 2>&1
        if [[ ! -e $parmanode_drive ]] ; then sudo mkdir -p $parmanode_drive ; fi
        sudo mount $disk $parmanode_drive 
        if ! mountpoint $parmanode_drive >/dev/null ; then announce "Drive didn't mount. There may be problems." ; fi
        sudo chown -R $USER:$(id -gn) $parmanode_drive 
        debug "label done"
        set_terminal
else
        debug "warning, make_label is $make_label"
        sudo umount $disk* 2>/dev/null ; sudo umount $parmanode_drive 2>/dev/null
        sudo umount /media/$USER/parmanod* 2>/dev/null
        if [[ ! -d /media/$USER/parmanode ]] ; then sudo mkdir -p /media/$USER/parmanode ; fi
        sudo mount $disk $parmanode_drive 
        if ! mountpoint $parmanode_drive >/dev/null ; then announce "Drive didn't mount. There may be problems." ; fi
        sudo chown -R $USER:$(id -gn) $parmanode_drive 
fi

    
write_to_fstab2 ; debug "fstab done"
clear
echo "Testing fstab mount..." ; sleep 2
sudo umount $parmanode_drive
sudo mount -a

if mountpoint $parmanode_drive >/dev/null 2>&1 ; then
cd /media/$USER/parmanode/
#change later and check this a mountpoint first
sudo mkdir .bitcoin fulcrum_db electrs_db > $dp/.temp 2>&1
debug "made .bitcoin, fulcrum and electrs dirs on the drive"
sudo chown $USER:$(id -gn) /media/$USER/parmanode # no -R in case it's another Node package drive that has been imported.
debug "chown parmanode drive"
sudo chown -R $USER:$(id -gn) .bitcoin fulcrum_db electrs_db
fi

if [[ -L /media/$USER/parmanode/.bitcoin ]] ; then
    if ! which readlink >/dev/null ; then sudo apt update -y && sudo apt install coreutils ; fi
    sudo chown -R $USER:$(id -gn) $(readlink /media/$USER/parmanode/.bitcoin)
fi
debug "chown parmanode directories"

set_terminal ; echo -e "
########################################################################################

    If you saw no errors, your drive should now be$green mounted$orange.

########################################################################################
"
enter_continue
return 0
}

