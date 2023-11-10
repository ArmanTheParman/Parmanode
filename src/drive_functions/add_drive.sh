function add_drive {

info_add_drive $@ || return 1 # safe unmount executed

set_terminal ; echo -e "$pink
########################################################################################
    Please make sure the$green drive you want to bring in$pink is PHYSICALLY DISCONNECTED, 
    before proceeding or else really bad things will happen to your computer.
########################################################################################
$orange" ; enter_continue

safe_unmount_parmanode || return 1

if [[ ! $wasntmounted == true ]] ; then
set_terminal ; echo -e "$cyan
########################################################################################
   Parmanode has safely unmounted your$green regular$cyan Parmanode drive by stopping 
   the programs using it, then unmounting. PLEASE MUST PHYSICALLY DISCONNECT THE DRIVE 
   NOW OR BAD THINGS WILL HAPPEN - NOT JOKING.
########################################################################################
" ; enter_continue ; set_terminal
fi

detect_drive $@ "brief" || return 1 #menu

label_check || return 1 

if [[ $OS == "Mac" ]] ; then
    set_terminal
    echo "
########################################################################################

    The drive should be ready. If it is not mounted, disconnect and reconnect.

########################################################################################
"
enter_continue ; return 0 ;
fi

if [[ $OS == "Linux" ]] ; then

    if [[ ! -d /media/$(whoami)/parmanode ]] ; then sudo mkdir -p /media/$(whoami)/parmanode ; fi
    
    write_to_fstab2

sudo mount -a

cd /media/$USER/parmanode/
sudo mkdir .bitcoin fulcrum_db electrs_db >/dev/null 2>&1
sudo chown -R $USER:$USER .bitcoin fulcrum_db electrs_db

set_terminal ; echo "
########################################################################################

    If you saw no errors, your drive should now be mounted.

########################################################################################
"
enter_continue
return 0
fi #end if Linux
}

function label_check {

if [[ $OS == "Mac" ]] ; then
    
    if cat $HOME/.parmanode/difference | grep "parmanode" ; then
    return 0 ; fi
    fi

if [[ $OS == "Linux" ]] ; then

    if [[ $LABEL == "parmanode" ]] ; then 
    return 0 ; fi
    fi

if [[ $OS == "Linux" ]] ; then

    if [[ $TYPE == "vfat" ]] ; then sudo fatlabel $disk parmanode 
    else sudo e2label $disk parmanode >/dev/null 
    fi
    return 0
fi # end if Linux

if [[ $OS == "Mac" ]] ; then
old_label=$(diskutil info $disk | grep "Volume Name:" | awk '{print $3}')
diskutil rename "${old_label}" "parmanode"
diskutil info $disk | grep -q "parmanode" || { announce "    There seems to be an error renaming the drive." && return 1 ; }
return 0
fi # end if Mac
}

