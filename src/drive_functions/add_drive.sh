function add_drive {

info_add_drive $@ || return 1 # safe unmount executed

set_terminal ; echo -e "$pink
########################################################################################
    Please make sure the$green drive you want to bring in$pink is PHYSICALLY DISCONNECTED, 
    before proceeding or else really bad things will happen to your computer.
########################################################################################
$orange" ; enter_continue

safe_unmount_parmanode || return 1

set_terminal ; echo -e "$cyan
########################################################################################
   If it was connected, Parmanode has safely unmounted your$green regular$cyan Parmanode 
   drive by stopping the programs using it, then unmounting. YOU MUST PHYSICALLY 
   DISCONNECT THE DRIVE NOW OR BAD THINGS WILL HAPPEN - NOT JOKING.
########################################################################################
" ; enter_continue ; set_terminal

detect_drive $@ || return 1 #menu
drive_details || return 1

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

    

function drive_details {

if [[ $OS == "Mac" ]] ; then
set_terminal
diskutil info $disk
debug "disk is $disk"
fi

    
if [[ $OS == "Linux" ]] ; then

export $(sudo blkid -o export $disk) >/dev/null
export LABEL UUID TYPE  

set_terminal
echo -e "
########################################################################################

    DETAILS OF THE DRIVE ...

        The label is $LABEL

        The UUID is ${UUID}

"
if [[ $1 == "after" ]] ; then
echo "
    Hit <enter> to continue
########################################################################################
" ; read ; return 0 ; fi
echo -e "
    Type$cyan yes$orange if you think this is correct, anything else to abort.

########################################################################################
"
read choice
case $choice in yes|YES|Yes|y|Y) return 0 ;; *) return 1 ;; esac
fi #ends if Linux

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

while true ; do
set_terminal ; echo -e "
########################################################################################

    The drive you wish to use needs to have the label,$cyan \"parmanode\"$orange. Go ahead and 
    have this changed now? (If there are errors here, you can rename the drive
    yourself, and return to this program to \"add\" the drive as a Parmanode drive.)

                        y)        Yes

                        n)        No (aborts)

########################################################################################
"
choose "xpmq" ; read choice
set_terminal
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
m|M) back2main ;;
y|Y|Yes|Yes|yes) break ;;
n|N|NO|No|no) return 1 ;;
*) invalid ;;
esac
done
if [[ $OS == "Linux" ]] ; then

    if [[ $TYPE == "vfat" ]] ; then sudo fatlabel $disk parmanode 
    else sudo e2label $disk parmanode >/dev/null 
    fi

    drive_details "after" ; if [ $? == 1 ] ; then return 1 ; fi
    return 0
fi # end if Linux

if [[ $OS == "Mac" ]] ; then
old_label=$(diskutil info $disk | grep "Volume Name:" | awk '{print $3}')
diskutil rename "${old_label}" "parmanode"
diskutil info $disk | grep -q "parmanode" || { announce "    There seems to be an error renaming the drive." && return 1 ; }
return 0
fi # end if Mac
}

