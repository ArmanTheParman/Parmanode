function umbrel_import {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

set_terminal ; echo -e "
########################################################################################
$cyan
                             UMBREL DRIVE IMPORT TOOL
$orange
    This program will convert your Umbrel external drive to make it compatible with
    Parmanode, preserving any Bitcoin block data that you may have already sync'd up.

    Simply use this convert tool, and plug into any parmanode computer (ParmanodL), 
    or plug it back into your Umbrel node - it'll still work.

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

while  mount | grep -q parmanode ; do 
set_terminal ; echo -e "
########################################################################################
    
    This function will$cyan refuse to run$orange if it detects an existing mounted 
    or even connected Parmanode drive. Bad things can happen. 

    If you want to continue, make sure any programs syncing to the drive (Bitcoin, or
    Fulcrum) have been stopped, then$pink unmount$orange the drive, then disconnect it,
    then come back to this function.

    Or, do you want Parmanode to attempt to cleanly stop everything and unmount the 
    drive for you?

               y)       Yes please, how kind.

               nah)     Nah ( = \"No\" in Straylian)

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in
p|P|nah|No|Nah|NAH|NO|n|N) return 1 ;;
q|Q) exit ;; 
y|Y|Yes|yes|YES)
safe_unmount_parmanode || return 1 
;;
*) invalid ;;
esac
done

while sudo blkid | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

            Please disconnect the Parmanode drive from the computer.

            Hit$cyan a$orange and then$cyan <enter>$orange to abort.

########################################################################################
"
read choice
case $choice in a|A) return 1 ;; esac
done


while ! sudo lsblk -o LABEL | grep -q umbrel ; do
set_terminal ; echo -e "
########################################################################################

    Please insert the Umbrel drive you wish to import, then hit$cyan <enter>.$orange

########################################################################################
"
read ; set_terminal ; sync
#Get device name
export disk=$(sudo blkid | grep umbrel | cut -d : -f 1) >/dev/null
done

#Mount
while ! sudo mount | grep -q umbrel ; do

    if mountpoint /media/$USER/parmanode ; then
    announce "There's a problem. The /media/$USER/parmanode directory is in use" \
    "It needs to be used for mounting the Umbrel drive. Aborting."
    return 1
    fi

    while ! mountpoint /media/$USER/parmanode ; do
    mount $drive /media/$USER/parmanode
    sleep 2
    done

done

export mount_point="/media/$USER/parmanode"

# Move files
#sudo mkdir -p $mount_point/.bitcoin
if [[ -d $mount_point/.bitcoin ]] ; then sudo mv $mount_point/.bitcoin $mount_point/.bitcoin_backup_0 
else
    sudo rm $mount_point/.bitcoin
fi

cd $mount_point/ && sudo ln -s ./umbrel/app-data/bitcoin/data/bitcoin/  .bitcoin 
sudo mkdir -p $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/
sudo mv $mount_point/umbrel/app-data/bitcoin/data/bitcoin/*.conf $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/
sudo chown $USER:$USER $mount_point/.bitcoin
make_bitcoin_conf umbrel
sudo mkdir -p $mount_point/electrs_db $mount_point/fulcrum_db >/dev/null 2>&1
sudo chown -R $USER:$USER $mount_point/electrs_db $mount_point/fulcrum_db >/dev/null 2>&1

# # Unmount Umbrel drive
# while mount | umbrel ; do
# cd $original_dir
# echo "Trying to unmount..."
# sudo umount $mount_point
# sleep 1
# done

# label
while sudo lsblk -o LABEL | grep -q umbrel ; do
echo "Changing the label to parmanode"
sudo e2label $disk parmanode 2>&1
sleep 1
done

# fstab configuration
while grep -q parmanode < /etc/fstab ; do
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

# Finished. Info.
set_terminal ; echo -e "
########################################################################################

    The drive data has been adjusted such that it can be used by Parmanode. It's
    label has been changed from$cyan umbrel to parmanode${orange}.

    The drive can still be used by Umbrel - swap over at your leisure. 

########################################################################################
" ; enter_continue ; set_terminal

#Conenct drive to Bitcoin Core
source $HOME/.parmanode/parmanode.conf
while [[ $drive == internal ]] ; do
source $HOME/.parmanode/parmanode.conf
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
source $HOME/.parmanode/parmanode.conf
done

# One more chance
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

#Info

set_terminal ; echo -e "
########################################################################################

    Please note, if you wish to use this new Parmanode drive on a computer different
    to this one, you should \"import\" it from the menu so the auto-mount feature can 
    be configured.

########################################################################################
" ; enter_continue

success "Umbrel Drive" "being imported to Parmanode."
}