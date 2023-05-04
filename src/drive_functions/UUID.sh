function remove_UUID_fstab {

drive_ID="$1"

get_UUID "${drive_ID}"

delete_line "/etc/fstab" "$UUID"
    
return 0
}

function get_UUID {

drive_ID=$1

        UUID=$(sudo blkid /dev/${drive_ID} | grep -o 'UUID="[^"]*"' | grep -o '"[^"]*"')
        UUID_temp=$(echo "$UUID" | sed 's/"//g')
        UUID=$UUID_temp

return 0
}

