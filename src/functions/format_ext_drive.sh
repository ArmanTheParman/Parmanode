function format_ext_drive {
	
set_terminal

#Warn the user to pay attention.
format_warnings
if [ $? == 1 ] ; then return 1 ; fi # return 1 means user skipped formatting.
select_drive_ID
if [ $? == 1 ] ; then return 1 ; fi

#User has typed sd? , or overidden the requirement, to proceed. All failures to this point return 1.

set_terminal

unmount

dd_wipe_drive   #function defined at the end of the file.

#partition function written below
partition_drive 

#Format the drive

sudo mkfs.ext4 -F /dev/$disk
enter_continue

#Mounting
sudo mkdir /media/$(whoami)/parmanode 2>/dev/null    #makes mountpoint
sudo mount /dev/$disk /media/$(whoami)/parmanode
sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode
sudo e2label /dev/$disk parmanode

#Extract the *NEW* UUID of the disk
UUID=$(sudo blkid /dev/$disk | grep -o 'UUID="[^"]*"' | grep -o '"[^"]*"')
UUID_temp=$(echo "$UUID" | sed 's/"//g')
UUID=$UUID_temp

#Write to fstab 
if grep -q $UUID /etc/fstab 
	    then
        echo "unable to write to fstab. You will have to manually mount the drive each time you boot up." 
        else 
	    echo "UUID=$UUID /media/$(whoami)/parmanode ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null 2>&1
fi

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
    
    Stay calm: YOU DON'T HAVE TO REMMEBER IT OR WRITE IT DOWN.  

    The /etc/fstab file has been updated to include the UUID and the drive should 
    automount on reboot.

########################################################################################
"
enter_continue

return 0
}