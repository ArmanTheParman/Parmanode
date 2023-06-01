function add_drive {

info_add_drive 

detect_drive

drive_details 
    if [ $? == 1 ] ; then return 1 ; fi

label_check ; if [ $? == 1 ] ; then return 1 ; fi

if [[ $OS == "Mac" ]] ; then
    set_terminal
    echo "
########################################################################################

    The drive should be ready. If it is not mounted, disconnect and reconnect.

########################################################################################
"
enter_continue ; return 0;
fi

if [[ $OS == "Linux" ]] ; then

    if [[ ! -d /media/$(whoami)/parmanode ]] ; then sudo mkdir -p /media/$(whoami)/parmanode ; fi
    
    write_to_fstab2

sudo mount -a

set_terminal ; echo "
########################################################################################

    If you saw no errors, your drive should now be mounted.

########################################################################################
"
enter_continue
return 0
fi #end if Linux
}

function detect_drive {

set_terminal pink ; echo "
########################################################################################

    Please pay careful attention here, otherwise you could get drive errors.

########################################################################################
"
enter_continue 

while true ; do
set_terminal ; echo "
########################################################################################

    Please make sure the drive you wish to add to Parmanode is DISCONNECTED. Do not 
    disconnect any of your other drives at this time.
    
    Hit <enter> only once this is done.

########################################################################################
"
read

if [[ $OS == "Linux" ]] ; then 
    sudo blkid -g >/dev/null
    sudo blkid > $HOME/.parmanode/before
    fi

if [[ $OS == "Mac" ]] ; then
    diskutil list > $HOME/.parmanode/before
    fi

set_terminal ; echo "
########################################################################################

    Now go ahead and re-connect the drive you wish to use for Parmanode. Do not 
    connect any other drive.

########################################################################################
"
enter_continue
set_terminal
sleep 2.5

if [[ $OS == "Linux" ]] ; then
    sudo blkid -g >/dev/null
    sudo blkid > $HOME/.parmanode/after
    fi

if [[ $OS == "Mac" ]] ; then
    diskutil list > $HOME/.parmanode/after
    fi

    disk_after=$(cat $HOME/.parmanode/after | grep . $HOME/.parmanode/after | tail -n1 ) 
    # grep . filters out empty lines
    disk_before=$(cat $HOME/.parmanode/before | grep . $HOME/.parmanode/before | tail -n1 )
debug1 "disk_before done"
    if [[ "$disk_after" == "$disk_before" ]] ; then 
        debug1 "after = $disk_after"
        debug1 "before = $disk_before"
        echo "No new drive detected. Try again. Hit <enter>."
            read ; continue 
        else
        debug1 "in else"
            if [[ $OS == "Linux" ]] ; then
                sed -i s/://g $HOME/.parmanode/after
                disk=$(grep . $HOME/.parmanode/after | tail -n1 | awk '{print $1}')
                echo "disk=\"$disk\"" > $HOME/.parmanode/var
                fi
            
            if [[ $OS == "Mac" ]] ; then
            debug1 "in os MAC"
                Ddiff=$(($(cat $HOME/.parmanode/after | wc -l)-$(cat $HOME/.parmanode/before |wc -l)))
                disk=$(grep . $HOME/.parmanode/after | tail -n $Ddiff | grep "dev" | awk '{print $1}')
                echo "$(cat $HOME/.parmanode/after | tail -n $Ddiff)" > $HOME/.parmanode/difference
                echo "disk=\"$disk\"" > $HOME/.parmanode/var
                fi

            break
    fi
    debug1 "before done"
done
}

function drive_details {
source $HOME/.parmanode/var

if [[ $OS == "Mac" ]] ; then
set_terminal
debug1 "disk is $disk"
diskutil info $disk
echo "
########################################################################################

    Type yes if you think this is the correct drive, anything else to abort.

########################################################################################
"
read choice ; 
case $choice in yes|YES|Yes|y|Y) return 0 ;; *) return 1 ;; esac
fi

    
if [[ $OS == "Linux" ]] ; then

export $(sudo blkid -o export $disk) >/dev/null
size=$(sudo lsblk $disk --noheadings | awk '{print $4'})
echo "size=\"$size\"" >> $HOME/.parmanode/var
echo "LABEL=\"$LABEL\"" >> $HOME/.parmanode/var
echo "UUID=\"$UUID\"" >> $HOME/.parmanode/var
echo "TYPE=\"$TYPE\"" >> $HOME/.parmanode/var

echo "
########################################################################################

    DRIVE DETAILS:

        The label is $LABEL

        The UUID is ${UUID}

        The drive size is $size

"
if [[ $1 == "after" ]] ; then
echo "
    Hit <enter> to continue
########################################################################################
" ; read ; return 0 ; fi
echo "
    Type yes if you think this is correct, anything else to abort.

########################################################################################
"
read choice
case $choice in yes|YES|Yes|y|Y) return 0 ;; *) return 1 ;; esac
fi #ends if Linux

}

function label_check {
source $HOME/.parmanode/var

if [[ $OS == "Mac" ]] ; then
    
    if cat $HOME/.parmanode/difference | grep "parmanode" ; then
    return 0 ; fi
    fi

if [[ $OS == "Linux" ]] ; then

    if [[ $LABEL == "parmanode" ]] ; then 
    return 0 ; fi
    fi

while true ; do
set_terminal ; echo "
########################################################################################

    The drive you wish to use needs to have the label, "parmanode". Go ahead and 
    have this changed now? (If there are errors here, you can rename the drive
    yourself, and return to this program to \"add\" the drive as a Parmanode drive.)

                        y)        Yes

                        n)        No (aborts)

########################################################################################
"
choose "xpq" ; read choice
set_terminal
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
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
    
   cat $HOME/.parmanode/difference

   echo "
######################################################################################## 

    Above are details about your drive. The Label is under the NAME column. Type it
    in exactly below (case sensitive) then hit <enter>

########################################################################################
"
read user_label 

diskutil rename "${user_label}" "parmanode"

set_terminal

if diskutil info $disk >/dev/null | grep "parmanode" ; then
    echo "    The label has been changed."
    enter_continue
    else
    echo "    There seems to be an error renaming the drive." 
    fi

fi # end if Mac
}

