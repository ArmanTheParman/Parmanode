function drive_encryption {

set_terminal ; echo -e "
########################################################################################$cyan
                        INFORMATION ON DRIVE ENCRYPTION$orange
########################################################################################
$cyan
    1.$orange Partition the drive if required, and gather device labels.
$cyan
    2.$orange Install cryptsetup:
$green
        sudo apt-get install cryptsetup
$cyan
    3.$orange Initialised Linux Unified Key Setup (LUKS) - you'll be asked to set a password
$green
        sudo cryptsetup luksFormat /dev/sdb1
$cyan
    4.$orange Open encrypted partition
$green
        sudo cryptsetup luksOpen /dev/sdb1 my_encrypted_drive
$cyan
    5.$orange Create filesystem
$green
        sudo mkfs.ext4 /dev/mapper/my_encrypted_drive
$cyan
    6.$orange When using the drive, use the Open command (step 4), then mount drive as usual.

########################################################################################
"
enter_continue ; jump $enter_cont

}