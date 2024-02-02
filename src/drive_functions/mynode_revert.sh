function mynode_revert {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
cd 
set_terminal ; echo -e "
########################################################################################
$cyan
                    DRIVE REVERT TOOL (Parmanode to MyNode)
$orange
    This program will revert your Parmanode external drive to back to MyNode.
    
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
choose "xpmq" ; read choice ; set_terminal
case $choice in
p|P|nah|No|Nah|NAH|NO|n|N) return 1 ;;
m|M) back2main ;;
q|Q) exit ;; 
y|Y|Yes|yes|YES)
safe_unmount_parmanode || return 1 
;;
*) invalid ;;
esac
done

while sudo lsblk -o LABEL | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

            Please disconnect all Parmanode drives from the computer.

            Hit <enter> once disconnected.

########################################################################################
"
read choice
done

if sudo lsblk -o LABEL | grep -q parmanode ; then announce "Parmanode drive still detected. Aborting." ; return 1 ; fi 

while ! sudo lsblk -o LABEL | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

    Now insert the Parmanode drive you wish to revert, then hit$cyan <enter>.$orange

########################################################################################
"
read ; set_terminal ; sync
done

#Mount
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) >/dev/null
export mount_point="/media/$USER/parmanode"
sudo umount /media/$USER/parmanode* >/dev/null 2>&1
sudo umount $disk >/dev/null 2>&1
sudo mount $disk $mount_point >/dev/null 2>&1


# The main changes...

cd $mount_point/.bitcoin
sudo rm ./*conf 
sudo mv ./parmanode_backedup/* ./
sudo chown -R 1002:1002 $mount_point/mynode/bitcoin

#Get device name
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) >/dev/null

# label
while sudo lsblk -o LABEL | grep -q parmanode ; do
echo "Changing the label to myNode"
sudo e2label $disk myNode 2>&1
sleep 1
done
# fstab configuration
# Finished. Info.
set_terminal ; echo -e "
########################################################################################

    The drive data has been adjusted such that it can be used again by MyNode. It's
    label has been changed from$cyan parmanode to myNode${orange}.

    The drive can no longer be used by Parmanode (you'd have to convert it again).

########################################################################################
" ; enter_continue ; set_terminal

cd
sudo umount $disk >/dev/null 2>&1
sudo umount /media/$USER/parmanode* 2>&1
sudo umount /media/$USER/parmanode 2>&1

# can't export everything, need grep, becuase if Label has spaces, causes error.
export $(sudo blkid -o export $disk | grep UUID) >/dev/null 
if grep -q $UUID < /etc/fstab ; then
delete_line "/etc/fstab" "$UUID"
fi

#Info
success "Parmanode Drive" "being reverted to MyNode." 
}