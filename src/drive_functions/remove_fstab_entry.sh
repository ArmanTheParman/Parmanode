function remove_parmanode_fstab {
delete_line "/etc/fstab" "parmanode"
}



# function remove_fstab_entry {
# #delete fstab entry of the disk immediately before wiping
# remove_UUID_fstab "$disk" 
# }

function remove_UUID_fstab {

drive_ID="$1"

get_UUID "${drive_ID}"
if [ -z $UUID ] ; then debug "No UUID, 2" ; return 1 ; fi
    
return 0
}

function get_UUID {

if ! lsblk -o LABEL | grep -q parmanode ; then
set_terminal ; echo -e "
########################################################################################
$red                   No Parmanode drive detected. Aborting. $orange
########################################################################################                  
"
enter_continue
return 1
fi

if [[ $(sudo blkid | grep parmanode | wc -l) == 1 ]] ; then #if there is only one parmanode in blkid...

    export UUID="$(sudo blkid | grep parmanode | cut -d " " -f 3 | cut -d \" -f 2)"
    debug "UUID in get_UUID is $UUID"

else
set_terminal ; echo -e "
########################################################################################
$red         More than one drive with the parmanode label detected. Aborting. $orange
########################################################################################
"
enter_continue
return 1
fi

 
}
