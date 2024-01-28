function remove_parmanode_fstab {
delete_line "/etc/fstab" "parmanode"
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
