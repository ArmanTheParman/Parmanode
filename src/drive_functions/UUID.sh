function remove_UUID_fstab {

drive_ID="$1"

get_UUID "${drive_ID}"
if [ -z $UUID ] ; then debug "No UUID, 2" ; return 1 ; fi
    
return 0
}

function get_UUID {

drive_ID=$1
if [ -z $drive_ID ] ; then debug "no drive_ID" ; return 1 ; fi

        UUID=$(sudo blkid /dev/${drive_ID} | grep -o 'UUID="[^"]*"' | grep -o '"[^"]*"')
        UUID_temp=$(echo "$UUID" | sed 's/"//g')
        UUID=$UUID_temp

return 0
}

