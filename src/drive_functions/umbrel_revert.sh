function umbrel_revert {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
cd
set_terminal ; echo -e "
########################################################################################
$cyan
                    DRIVE REVERT TOOL (Parmanode to Umbrel)
$orange
    This program will revert your Parmanode external drive to back to Umbrel.
    
########################################################################################
"
choose "eq" ; read choice
case $choice in q|Q|P|p) return 1 ;; *) true ;; esac

while sudo mount | grep -q parmanode ; do 
set_terminal ; echo -e "
########################################################################################
    
    This function needs to make sure the Parmanode drive is not mounted. Please also
    do not connect two Parmanode drives at the same time.

    Do you want Parmanode to attempt to cleanly stop everything and unmount the 
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
debug "1"

while sudo lsblk -o LABEL | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

            Please disconnect all Parmanode drives from the computer.

            Hit <enter> once disconnected.

########################################################################################
"
read choice
done

debug "2"
if sudo lsblk -o LABEL | grep -q parmanode ; then announce "Parmanode drive still detected. Aborting." ; return 1 ; fi 

while ! sudo lsblk -o LABEL | grep -q parmanode ; do
debug "2a"
set_terminal ; echo -e "
########################################################################################

    Now insert the Parmanode drive you wish to revert, then hit$cyan <enter>.$orange

########################################################################################
"
read ; set_terminal ; sync
done
debug "2c"

export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) >/dev/null
debug "2c2 , disk is $disk"

#Mount
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) >/dev/null
export mount_point="/media/$USER/parmanode"
sudo umount /media/$USER/parmanode* >/dev/null 2>&1
sudo umount $disk >/dev/null 2>&1
sudo mount $disk $mount_point >/dev/null 2>&1



debug "33"

# The main changes...

cd $mount_point/.bitcoin
sudo rm ./*.conf 
sudo mv ./parmanode_backedup/* ./
sudo chown -R 1000:1000 $mount_point/umbrel/app-data/bitcoin/data/bitcoin/ 
#Get device name
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) >/dev/null
debug "5b , disk is $disk"

# label
while sudo lsblk -o LABEL | grep -q parmanode ; do
echo "Changing the label to umbrel"
sudo e2label $disk umbrel 2>&1
sleep 1
done
debug "6"
# fstab configuration
# Finished. Info.
set_terminal ; echo -e "
########################################################################################

    The drive data has been adjusted such that it can be used again by Umbrel. It's
    label has been changed from$cyan parmanode to umbrel${orange}.

    The drive can no longer be used by Parmanode (you'd have to convert it again).

########################################################################################
" ; enter_continue ; set_terminal

sudo umount $disk >/dev/null 2>&1
sudo umount /media/$USER/parmanode* 2>&1
sudo umount /media/$USER/parmanode 2>&1
debug "unmounted?"
announce "It's possible the drive icon might still be seen on the" \
"desktop, and the label cour be inaccurate. Just unmount or reboot."

export $(sudo blkid -o export $disk) >/dev/null
if grep -q $UUID < /etc/fstab ; then
delete_line "/etc/fstab" "$UUID"
fi

#Info
success "Parmanode Drive" "being reverted to Umbrel." 
}