function raspiblitz_revert {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
cd
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                    DRIVE REVERT TOOL (Parmanode to RaspiBlizt)
$orange
    This program will revert your Parmanode external drive to back to RaspiBlitz.
    
########################################################################################
"
choose "eq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q|P|p) return 1 ;; *) break ;; esac
done

while sudo mount | grep -q parmanode ; do 
set_terminal ; echo -e "
########################################################################################
    
    This function needs to make sure the Parmanode drive is not mounted. Also, please
    do not connect two Parmanode drives at the same time.

    Do you want Parmanode to attempt to cleanly stop everything and unmount the 
    drive for you?
$green
               y)       Yes please, how kind.
$red
               nah)     Nah ( = 'No' in Straylian)
$orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P|nah|No|Nah|NAH|NO|n|N) return 1 ;;
y|Y|Yes|yes|YES)
safe_unmount_parmanode || return 1 
;;
*) invalid ;;
esac
done

while sudo lsblk -o LABEL | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

            Please$pink physically disconnect$orange all Parmanode drives from the computer.

            Hit$green <enter>$orange once disconnected.

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

export disk=$(sudo blkid | grep parmanode | cut -d : -f 1)

#Mount
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1)
export mount_point="/media/$USER/parmanode"
sudo umount /media/$USER/parmanode* >$dn 2>&1
sudo umount $disk >$dn 2>&1
sudo mount $disk $mount_point >$dn 2>&1




# The main changes...

cd $mount_point/.bitcoin
sudo rm ./*.conf >$dn 2>&1
sudo mv ./parmanode_backedup/* ./
sudo chown -R 118:126 $mount_point/bitcoin
#Get device name
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) 

# label
while sudo lsblk -o LABEL | grep -q parmanode ; do
echo "Changing the label to BLOCKCHAIN"
sudo e2label $disk BLOCKCHAIN >$dn 2>&1
sleep 1
sudo partprobe 2>/dev/null
done
# fstab configuration
# Finished. Info.
set_terminal ; echo -e "
########################################################################################

    The drive data has been adjusted such that it can be used again by RaspiBlitz. 
    It's label has been changed from parmanode to$cyan BLOCKCHAIN${orange}.

    When you boot up the RaspiBlitz on your Pi, it may struggle to restart and detect
    the bitcoin data. If after 10 minutes, there isn't any suggestion it has restarted
    to sync, then a restart should work, or, access the terminal and type:
$cyan
        sudo systemctl status bitcoind.service
$orange
    Also note, the drive can no longer be used by Parmanode (you'd have to convert 
    it again).

########################################################################################
" ; enter_continue ; set_terminal

cd
sudo umount $disk >$dn 2>&1
sudo umount /media/$USER/parmanode* >$dn 2>&1
sudo umount /media/$USER/parmanode >$dn 2>&1

# can't export everything, need grep, becuase if Label has spaces, causes error.
export $(sudo blkid -o export $disk | grep UUID) 
if grep -q $UUID < /etc/fstab ; then
sudo gsed -i "/parmanode/d" /etc/fstab
fi

#Info
success "Parmanode Drive" "being reverted to RaspiBlitz." 
}