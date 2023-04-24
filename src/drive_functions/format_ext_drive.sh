function format_ext_drive {
format_warnings     #Warn the user to pay attention.
    if [ $? == 1 ] ; then return 1 ; fi # return 1 means user skipped formatting.
    select_drive_ID
    if [ $? == 1 ] ; then return 1 ; fi

log "bitcoin" "unmounting function..."
   unmount   #failure here exits program


log "bitcoin" "dd_wipe_drive function..."
   dd_wipe_drive  #failure here exits program 

if [[ $OS == "Linux" ]] ; then partition_drive ; fi   # Partition step not required for Mac

#Format the drive
if [[ $OS == "Mac" ]] ; then
        set_terminal
        log "bitcoin" "eraseDisk $disk ..."
        diskutil eraseDisk exFAT "parmanode" $disk \
            || log "bitcoin" "failed to eraseDisk"   
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

        #delete fstab entry of the disk immediately before formatting
        remove_UUID_fstab "$disk" && log "bitcoin" "UUID removed for $disk from fstab"

        sudo mkfs.ext4 -F /dev/$disk && log "bitcoin" "mkfs done" && \
        enter_continue

        #Mounting
        sudo mkdir /media/$(whoami)/parmanode >> $HOME/.parmanod/bitcoin.log 2>&1    
        sudo mount /dev/$disk /media/$(whoami)/parmanode >> $HOME/.parmanod/bitcoin.log 2>&1 
        sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >> $HOME/.parmanod/bitcoin.log 2>&1 
        sudo e2label /dev/$disk parmanode >> $HOME/.parmanod/bitcoin.log 2>&1 

        #Extract the *NEW* UUID of the disk and write to config file.
        get_UUID "$disk" && parmanode_conf_add "UUID=$UUID" && log "bitcoin" "new UUID $UUID"

        #Write to fstab 
        echo "UUID=$UUID /media/$(whoami)/parmanode ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null 2>&1
        
        log "bitcoin" "fstab grep output for parmanode:" && \
        grep "parmanode" /etc/fstab >> $HOME/.parmanode/bitcoin.log     
    
        #confirmation output.
        echo "Some more cool computer stuff happened in the background."
        enter_continue # pause not required as all the above code has no output
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
