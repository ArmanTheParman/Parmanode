function umbrel_import_reverse {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

set_terminal ; echo -e "
########################################################################################
$cyan
                         UMBREL DRIVE REVERSE IMPORT TOOL
$orange
    This program will revert your Parmanode external drive to an Umbrel drive,
    preserving Bitcoin block data. 

    This only works if you previously used the Umbrel Drive Import Tool on this
    drive.

########################################################################################
" ; enter_continue ; set_terminal

if lsblk -o Label | grep parmanode || lsblk -o Label | grep umbrel ; then
echo "Unmounting Parmanode drive first..."
safe_unmount_parmanode || return 1
sudo systemctl stop bitcoind.service fulcrum.service electrs.service
sudo umount /media/$USER/parmanode 2>/dev/null
sudo umount /media/$USER/umbrel 2>/devlnull
sleep 2
fi

if ! mountpoint /media/$USER/parmanode ; then
echo -e "
########################################################################################

   Unmounting any Parmanode drive should have been successful. Please phsyically 
   detact any Parmanode drive, or you're likely to get errors.

                    $cyan
                        <enter>$orange     to continue
                    $cyan
                        a $orange          to abort

######################################################################################## 
" ; read choice ; case $choice in a|A) return 1 ;; esac
else
announce "couldn't unmount. aborting." ; return 1
fi

set_terminal

# detect drive and make sure it really was an umbrel drive
echo -e "
########################################################################################

    Now go ahead and CONNECT the$cyan target Converted Umbrel-to-Parmanode $orange drive 
    now, then hit <enter>.

    ANY OTHER PARMANODE DRIVE MUST BE PHYSICALLY DISCONNCTED.

########################################################################################
"
enter_continue

# Mount
while true ; do

if [[ $(sudo lsblk | grep parmanode | wc -l) == 1 ]] ; then
export mount_point=$(lsblk | grep parmanode | grep -o /.*$)
mounted=true
break
else
announce "Parmanode drive not detected. <enter> to try again."
continue
mounted=false
fi
done

if [[ $(sudo blkid | grep parmanode | wc -l) == 1 ]] ; then
unset disk 
export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) 
fi

if [[ $mounted == false ]] ; then 
sudo mkdir -p /media/$USER/parmanode
sudo mount $disk /media/$USER/parmanode
export mount_point="/media/$USER/parmanode"
fi

#check it's really an old Umbrel drive
if [[ ! -e $mount_point/umbrel ]]  ; then
set_terminal ; echo "
########################################################################################

    This drive does not appear to have ever been an Umbrel drive in the past.

    Aborting.

########################################################################################
"
enter_continue ; return 1
fi

# Capture username, group, and UID and GID
U_username=$(stat -c %U $mount_point/umbrel/LICENSE.md)
U_groupname=$(stat -c %G $mount_point/umbrel/LICENSE.md)
U_userID=$(stat -c %u $mount_point/umbrel/LICENSE.md)
U_groupID=$(stat -c %g $mount_point/umbrel/LICENSE.md)

# Set previous permissions
target="$mount_point/umbrel/app-data/bitcoin/data/bitcoin/"
sudo chown -R $U_username:$U_groupname $mount_point/.bitcoin
sudo chown -R $U_userID:$U_groupID $mount_point/.bitcoin

# Move files
cd $mount_point/.bitcoin
mv blocks chainstate indexes "$target"

# Remove fstab
delete_line "/etc/fstab" "parmanode"

# Label drive
sudo e2label $disk umbrel 2>&1

success "The Umbrel Drive" "finished being recovered."

}