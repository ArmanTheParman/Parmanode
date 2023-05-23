function add_drive {

info_add_drive 

detect_drive

drive_details ; if [ $? == 1 ] ; then return 1 ; fi

label_check ; if [ $? == 1 ] ; then return 1 ; fi

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

sudo blkid -g >/dev/null
before=$(sudo blkid) >/dev/null 2>&1 ; echo "\"before=$before\"" > $HOME/.parmanode/tmp

set_terminal ; echo "
########################################################################################

    Now go ahead and re-connect the drive you wish to use for Parmanode. Do not 
    connect any other drive.

########################################################################################
"
enter_continue
    sudo blkid -g >/dev/null
    after=$(sudo blkid) >/dev/null 2>&1 ; echo "\"after=$after\"" >> $HOME/.parmanode/tmp

    disk=$(diff <(echo $before) <(echo $after) | grep -E "^>" | awk '{print $3}')
        echo "disk=\"$disk\"" >> $HOME/.parmanode/tmp

    disk2=$(diff <(echo $before) <(echo $after) 
    echo "$disk2" > $HOME/.parmanode/disk2

    if [[ -z $disk ]] 
        then echo "No new drive detected. Try again. Hit <enter>."
            read ; continue 
        else
            break
    fi
done
}

function drive_details {
source $HOME/.parmanode/tmp
    
export $(sudo blkid -o export $disk) >/dev/null
size=$(sudo lsblk $disk --noheadings | awk '{print $4'})
echo "size=\"$size\"" > $HOME/.parmanode/var
echo "LABEL=\"$LABEL\"" >> $HOME/.parmanode/var
echo "UUID=\"$UUID\"" >> $HOME/.parmanode/var
echo "TYPE=\"$TYPE\"" >> $HOME/.parmanode/var

echo "
########################################################################################

    Drive details:

    The label is $LABEL

    The UUID is ${UUID}

    The drive size is $size


    Type yes if you think this is correct, anything else to abort.

########################################################################################
"
read $choice
case $choice in yes|YES|Yes|y|Y) return 0 ;; *) return 1 ;; esac
}

function label_check {
source $HOME/.parmanode/tmp

if [[ $LABEL == "parmanode" ]] ; then return 0 ; fi

while true ; do
set_terminal ; echo "
########################################################################################

    The drive you wish to use needs to have the label, "parmanode". Go ahead and 
    have this changed now?

                        y)        Yes

                        n)        No (aborts)

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
y|Y|Yes|Yes|yes) break ;;
n|N|NO|No|no) return 1 ;;
*) invalid ;;
esac
done

if [[ $TYPE == "vfat" ]] ; then sudo fatlabel $disk parmanode 
else sudo e2label $disk parmanode
fi

drive_details ; if [ $? == 1 ] ; then return 1 ; fi
return 0
}

