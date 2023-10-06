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
export $mount_point=/media/$USER/parmanode

# Unmount Parmanode drive
while mount | parmanode ; do
cd $original_dir
echo "Trying to unmount Parmanode first..."
sleep 1
safe_unmount_parmanode || return 1
sleep 1
done


if ! mountpoint /media/$USER/parmanode >/dev/null 2>&1 ; then
echo -e "
########################################################################################

   Unmounting any Parmanode drive should have been successful. Please phsyically $cyan
   DISCONNECT$orange ANY Parmanode drive, or you're likely to get errors.

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

while ! sudo blkid | grep parmanode ; do
announce "It doesn't seem like the Parmanode drive is physically conected." \
"Please try again"
done

export disk=$(sudo blkid | grep parmanode | cut -d : -f 1) 

# Mount
while ! mount | grep parmanode ; do
echo "Mounting parmanode drive..."
mount_drive menu
done

#check it's really an old Umbrel drive
if [[ ! -e $mount_point/umbrel ]]  ; then
debug " $mount_point/umbrel"
set_terminal ; echo -e "
########################################################################################

    This drive does not appear to have ever been an Umbrel drive in the past.

    Aborting.

########################################################################################
"
enter_continue ; return 1
fi
debug "after mountpoint umbrel check, after if"

# Capture username, group, and UID and GID
U_username=$(stat -c %U $mount_point/umbrel/LICENSE.md)
U_groupname=$(stat -c %G $mount_point/umbrel/LICENSE.md)
U_userID=$(stat -c %u $mount_point/umbrel/LICENSE.md)
U_groupID=$(stat -c %g $mount_point/umbrel/LICENSE.md)
debug "stat captured. 4 values... $U_username $U_groupname $U_userID $U_groupID"

# Set previous permissions
target="$mount_point/umbrel/app-data/bitcoin/data/bitcoin/"
sudo chown -R $U_username:$U_groupname $mount_point/.bitcoin
sudo chown -R $U_userID:$U_groupID $mount_point/.bitcoin
debug "target=$target"

# Move files
cd $mount_point/.bitcoin
mv blocks chainstate indexes "$target"
sudo rm bitcoin.conf
cd ~
debug "moved files"

# Remove fstab
delete_line "/etc/fstab" "parmanode"
debug "fstab line removed"

# Label drive
sudo e2label $disk umbrel 2>&1
debug "drive label for $disk changed to umbrel?"

# unmount drive again
sudo umount $mount_point
debug "unmounted from mountpoint=$mount_point"

success "The Umbrel Drive" "finished being recovered."
}