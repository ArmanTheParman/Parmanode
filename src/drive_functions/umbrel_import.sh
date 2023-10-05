function umbrel_import {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

set_terminal ; echo -e "
########################################################################################
$cyan
                             UMBREL DRIVE IMPORT TOOL
$orange
    This program will convert your Umbrel external drive to a Parmanode drive,
    preserving any Bitcoin block data that you may have already sync'd up.

    All the Umbrel data will be preserved so you can use Parmanode to revert the 
    drive back, but no promises are made that it will work. Use the reversion function
    at your own risk.
$pink
    It's safest to assume the non-bitcoin Umbrel data will be lost${orange}. If you 
    have funds in lightning, please make sure all relevant data is backed up.

########################################################################################
"
choose "eq" ; read choice
case $choice in q|Q|P|p) return 1 ;; *) true ;; esac

while true ; do
set_terminal ; echo -e "$pink
########################################################################################

    ARE YOU SURE YOU WANT TO CONTINUE?    y   or   n

########################################################################################
"
read choice
case $choice in n|N) return 1 ;; y|Y) break ;; *) invalid ;; esac
done

# # Disconnect any parmanode drive
# if sudo lsblk | grep parmanode ; then 
# set_terminal ; echo -e "
# ########################################################################################

#     Please remove the parmanode drive. If you have Bitcoin syncing to it, you need to 
#     stop it first before, and come back to this. If it's running, also stop Fulcrum
#     and electrs. Then eject the drive.

#     Exiting now, but come back and try again once the drive is disconnected.

# ########################################################################################
# "
# enter_continue ; return 1
# fi

set_terminal ; echo -e "
########################################################################################

    Please note that this action must be undertaken on the same computer that the
    drive is destined to be used on - otherwise the import will be incomplete, and
    you may get unexpected errors.

                                a)          to abort
                                
                                <enter>     to continue

########################################################################################
"
read choice
if [[ $choice == a ]] ; then return 1 ; fi


while true ; do
set_terminal ; echo -e "
########################################################################################

    Please insert the Umbrel drive you wish to import, then hit <enter>.

########################################################################################
"
read 
clear

sync

if [[ $(sudo lsblk | grep umbrel | wc -l) == 1 ]] ; then    # only one umbrel disk detected as mounted 

    export mount_point=$(lsblk | grep umbrel | grep -o /.*$)
    mounted=true
    break

elif sudo lsblk | grep umbrel ; then
    
    announce "More than one umbrel drive detected. Aborting." ; return 1

elif [[ $(sudo blkid | grep umbrel | wc -l) == 1 ]] ; then

    mounted=false
    break

else
   announce "No Umbrel drive detected. Try again." 
   continue
fi 

done

unset disk 
export disk=$(sudo blkid | grep umbrel | cut -d : -f 1) 

if [[ $mounted == false ]] ; then 
sudo mkdir -p /media/$USER/umbrel
sudo mount $disk /media/$USER/umbrel 
if [ $? -ne 0 ] ; then
sudo mount -L umbrel /media/$USER/umbrel
fi
export mount_point="/media/$USER/umbrel"
fi

#Mounting should be done.
if mountpoint /media/$USER/umbrel >/dev/null || $(sudo lsblk | grep umbrel | awk '{print $7}' | grep umbrel ) ; then
mounted=true
debug "umbrel should be mounted: mounted=$mounted"
else
announce "Couldn't mount. Aborting."
return 1
fi

# Move files

sudo mkdir -p $mount_point/.bitcoin
cd $mount_point/umbrel/app-data/bitcoin/data/bitcoin/
mv blocks chainstate indexes $mount_point/.bitcoin
sudo chown -R $USER:$USER $mount_point/.bitcoin

# Unmount Umbrel drive
if [[ -z $mount_point ]] ; then export mount_point=$(lsblk | grep umbrel | grep -o /.*$) ; fi
debug "mountpoint before umounting is $mount_point; pwd is $(pwd)"
cd $original_dir
sudo umount $mount_point

# Check if unmounted
if mountpoint $mount_point ; then 
announce "Couln't unmount Umbrel drive. Please try yourself, then hit <enter> when" \
"you think it's done."
fi

if mountpoint $mount_point ; then
sudo mv -r $mount_point/.bitcoin/* $mount_point/umbrel/app-data/bitcoin/data/bitcoin/
sudo rm -rf $mount_point/.bitcoin
announce "Couldn't unmount to proceed. Changes reversed. Aborting."
fi

# label
sudo e2label $disk parmanode 2>&1

# fstab configuration
if sudo cat /etc/fstab | grep parmanode ; then
while true ; do
set_terminal ; echo "
########################################################################################

    There already seems to be a Parmanode drive configured to auto-mount at system
    boot. 
    
    You can only have one at a time. 
    
    Would you like to replace the old drive with the new drive from Umbrel for this
    computer?

                          y        or        n

########################################################################################
"
choose "x" ; read choice
case $choice in y|Y)
export $(sudo blkid -o export $disk) >/dev/null
delete_line "/etc/fstab" "parmanode"
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null 2>&1
break
;;
n|N)
export fstab_setting=wrong
break
;;
*)
invalid ;;
esac
done
fi

# Done

set_terminal ; echo -e "
########################################################################################

    The drive data has been rearranged such that it can be used by Parmanode. It's
    label has been changed from umbrel to parmanode.

    The data can no longer be used by Umbrel - if you reconnect now to Umbrel, it may
    get automatically formated. Be warned.

    If you want to reverse the changes and go back to Umbrel, you can do that from
    the Parmanode Tools menu. Like I said before, no gaurantees.

########################################################################################
" ; enter_continue ; set_terminal

#Conenct drive to Bitcoin Core
unset drive 
soucre $HOME/.parmanode/parmanode.conf

if [[ $drive == internal ]] ; then
set_terminal ; echo -e "
########################################################################################

        Parmanode will now change the syncing directory from Internal to External.
  
        Hit <enter> to accept, or a to abort.

        If you abort, you'l have to select to swap internal vs external from the
        Parmanode Bitcoin menu.

########################################################################################    
"
choose "xpq"
case $choice in a|A|q|Q|P|p) return 1 ;; esac

change_bitcoin_drive change
fi


if [[ $drive == external && $fstab_setting == wrong ]] ; then
while true ; do
echo -e "
########################################################################################

    When you replace the old Parmanode drive with this one, Bitcoin will sync up 
    with the data on this new drive. However, because you chose to not remove the
    old auto-mount configuration earlier for the old drive, when the system boots up, 
    the old drive will be expected and Bitcoin will fail to auto start.

    Remove the old auto-mount setting and use the current drive?

                    y          or          n 

########################################################################################
"
choose "x" ; read choice
set_terminal
case $choice in y|Y)
export $(sudo blkid -o export $disk) >/dev/null
delete_line "/etc/fstab" "parmanode"
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >/dev/null 2>&1
break
;;
n|N)
export fstab_setting=wrong
break
;;
*)
invalid ;;
esac
done
fi

set_terminal ; echo -e "
########################################################################################

    Please note, if you wish to use this new Parmanode drive on a computer different
    to this one, you should \"import\" it from the menu so the auto-mount feature can 
    be configured.

    Also if that computer is already syncing to an internal drive, then you'll need
    to uninstall Bitcoin (keep the block data if you want) and re-install with the
    new drive.

########################################################################################
" ; enter_continue
}