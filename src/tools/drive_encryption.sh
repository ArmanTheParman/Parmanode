function drive_encryption {

set_terminal ; echo -e "
########################################################################################$cyan
                        INFORMATION ON DRIVE ENCRYPTION$orange
########################################################################################

    1. Partition the drive if required, and gather device labels.

    2. Install cryptsetup:
$cyan
        sudo apt-get install cryptsetup
$orange
    3. Initialised Linux Unified Key Setup (LUKS) - you'll be asked to set a password
$cyan
        sudo cryptsetup luksFormat /dev/sdb1
$orange    
    4. Open encrypted partition
$cyan
        sudo cryptsetup luksOpen /dev/sdb1 my_encrypted_drive
$orange        
    5. Create filesystem
$cyan
        sudo mkfs.ext4 /dev/mapper/my_encrypted_drive
$orange
    6. When using the drive, use the Open command (step 4), then mount drive as usual.

########################################################################################
"
enter_continue

}