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
debug "arg 1 is $1"
drive_ID=${1}
debug "drive ID is $drive_ID"
if [ -z $drive_ID ] ; then debug "no drive_ID" ; return 1 ; fi

        # UUID=$(sudo blkid $drive_ID} | grep -o 'UUID="[^"]*"' | grep -o '"[^"]*"')
        # UUID_temp=$(echo "$UUID" | sed 's/"//g')
        # export UUID=$UUID_temp
        if [[ $(sudo blkid | grep parmanode | wc -l) == 1 ]] ; then 
        export UUID="$(sudo blkid | grep parmanode | cut -d " " -f 3 | cut -d \" -f 2)"
        debug "UUID in get_UUID is $UUID"
        else
        announce "error extracting UUID, aborting"
        return 1

return 0 
}
