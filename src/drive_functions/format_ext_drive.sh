function format_ext_drive {

#quit if internal drive chosen
if [[ $1 == "Bitcoin" && $drive == "internal" ]] ; then return 0 ; fi
if [[ $1 == "Fulcrum" && $drive_fulcrum == "internal" ]] ; then return 0 ; fi
if [[ $1 == "electrs" && $drive_electrs == "internal" ]] ; then return 0 ; fi

#quit if external drive set for either of the other programs that use this function
if [[ $1 == "Bitcoin" && $drive == "external" && $drive_fulcrum == "external" || $drive_electrs == "external" ]] ; then return 0 ; fi
if [[ $1 == "Fulcrum" && $drive_fulcrum == "external" && $drive == "external" || $drive_electrs == "external" ]] ; then return 0 ; fi
if [[ $1 == "electrs" && $drive_electrs == "external" && $drive == "external" || $drive_fulcrum == "external" ]] ; then return 0 ; fi

format_warnings || return 1 # return 1 means user skipped formatting.

#select_drive_ID || return 1 #gets $disk variable (exported)
detect_drive || return 1 #alternative (better) way to get $disk variable, and exported.

unmount   #failure here exits program. Need drive not to be mounted in order to wipe and format.
dd_wipe_drive  #failure here exits program 

if [[ $OS == "Linux" ]] ; then partition_drive ; fi   # Partition step not required for Mac

#Format the drive
if [[ $OS == "Mac" ]] ; then
        set_terminal
        log "bitcoin" "eraseDisk $disk ..."
        if [[ $chip == "arm64" ]] ; then # arm chip computers have a different file system
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
        # The following function is redundant, but added in case the dd function (which
        # calls this function earlier is discarded). 
        remove_parmanode_fstab
        
        # Formats the drive and labels it "parmanode" - uses standard linux type, ext4
        sudo mkfs.ext4 -F -L "parmanode" $disk 

        #Extract the *NEW* UUID of the disk and write to config file.
        get_UUID "$disk" && parmanode_conf_add "UUID=$UUID"

        write_to_fstab "$UUID"

        # Mounting... Make the mount directory, mount the drive, set the permissions,
        # and label drive (Last bit is redundant)
        sudo mkdir /media/$(whoami)/parmanode 2>&1    
        sudo mount $disk /media/$(whoami)/parmanode 2>&1 
        sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode 2>&1 
        sudo e2label $disk parmanode 2>&1 

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
