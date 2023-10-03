function umbrel_import_reverse {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

set_terminal ; echo -e "
########################################################################################
$cyan
                         UMBREL DRIVE REVERSE IMPORT TOOL
$orange
    This program will revert your Parmanode external drive to an Umbrel drive,
    preserving Bitcoin block data. 

    This only works if you previously used tthe Umbrel Drive Import Tool on this
    drive.
$pink
    Go ahead and connect the drive now.
$orange
########################################################################################
" ; enter_continue ; set_terminal

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