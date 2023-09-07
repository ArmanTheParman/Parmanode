function format_ext_drive {
format_warnings     #Warn the user to pay attention.
    if [ $? == 1 ] ; then return 1 ; fi # return 1 means user skipped formatting.
    select_drive_ID
    if [ $? == 1 ] ; then return 1 ; fi

unmount   #failure here exits program. Need drive not to be mounted in order to wipe and format.

dd_wipe_drive  #failure here exits program 

if [[ $OS == "Linux" ]] ; then partition_drive ; fi   # Partition step not required for Mac

#Format the drive
if [[ $OS == "Mac" ]] ; then
        set_terminal
        log "bitcoin" "eraseDisk $disk ..."
        if [[ $(uname -m) == "arm64" ]] ; then
        diskutil eraseDisk APFS "parmanode" $disk || log "bitcoin" "failed to eraseDisk"
        else
        diskutil eraseDisk exFAT "parmanode" $disk || log "bitcoin" "failed to eraseDisk"   
        fi
        set_terminal ; echo "
#######################################################################################

    If you saw no errors, then the $disk drive has been wiped, formatted, mounted, 
    and labelled as \"parmanode\".

#######################################################################################
    "
    enter_continue
    return 0
    fi

if [[ $OS == "Linux" ]] ; then
        #in case I allow no wiping in future version, duplicating this function
        #it wipes a nonsense UUID if the drive has just been wiped, so no harm.
        remove_fstab_entry
        sudo mkfs.ext4 -F -L "parmanode" /dev/$disk 

        #Extract the *NEW* UUID of the disk and write to config file.
        get_UUID "$disk" && parmanode_conf_add "UUID=$UUID"

        write_to_fstab "$UUID"

        #Mounting
        sudo mkdir /media/$(whoami)/parmanode 2>&1    
        sudo mount /dev/$disk /media/$(whoami)/parmanode 2>&1 
        sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode 2>&1 
        sudo e2label /dev/$disk parmanode 2>&1 

        parmanode_conf_add "UUID=$UUID"
        set_terminal
        echo "
#######################################################################################

    If you saw no errors, then the $disk drive has been wiped, formatted, mounted, 
    and labelled as \"parmanode\".
    
    The drive's UUID, for reference, is $UUID.

    A drive's UUID (Universally Unique Identifier) is a unique identifier assigned 
    to a storage device (like a hard drive, SSD, or USB drive) to distinguish it 
    from other devices. 
    
    Stay calm: YOU DON'T HAVE TO REMEMBER IT OR WRITE IT DOWN.  
               This is just information for you, you can ignore it.

    The /etc/fstab file has been updated to include the UUID and the drive should 
    automount on reboot. If you don't understand that, don't worry about it, just 
    proceed.

########################################################################################
        "
        enter_continue
fi
return 0
}
