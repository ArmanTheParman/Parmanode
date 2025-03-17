function menu_drives {

if [[ $OS == "Mac" ]] ; then menu_drives_mac || return 1 ; return 0 ; fi

if ! mount | grep -q parmanode ; then 
    mounted="false"
else
    mounted="true"
fi

#External
eID=$(mount | grep parmanode | tail -n1 | awk '{print $1}')
eblocksize=$(sudo tune2fs -l $eID | grep -E 'Block size' | awk '{print $3}')
if [[ $mounted == "true" ]] ; then
emenu="$green    EXTERNAL: (mounted)
$orange                                                                         
                 Device ID:                   $green$eID $orange
                 Total space:                 $green$(df -h | grep $eID | awk '{print $2}') $orange
                 Free space:                  $green$(df -h | grep $eID | awk '{print $4}') $orange 
                 Label:                       $green$(sudo e2label $eID) $orange
                 UUID:                        $green$(sudo tune2fs -l $eID | grep UUID | awk '{print $3}') $orange
                 Mountpoint:                  $green$(mount | grep $eID | awk '{print $3}') $orange
                 Reserved 'system' space:     $green$(($(sudo tune2fs -l $eID | grep -E Reserved.+count | awk '{print $4}') * $eblocksize / (1024*1024*1024) ))G
$orange"
else
emenu="$red    EXTERNAL: (not mounted)$orange"
fi

#Internal

iID=$(lsblk -nr -o PATH,MOUNTPOINT | grep -E '/$' | awk '{print $1}')
iblocksize=$(sudo tune2fs -l $iID | grep -E 'Block size' | awk '{print $3}')
debug "before menu"
set_terminal_custom 49 ; echo -e "
########################################################################################$cyan
                                Parmanode Drive Menu$orange
########################################################################################

$emenu
$green    INTERNAL:
$orange
                 Device ID:                   $green$iID $orange
                 Total space:                 $green$(df -h | grep -E '/$' | awk '{print $2}') $orange
                 Free space:                  $green$(df -h | grep -E '/$' | awk '{print $4}') $orange
                 Reserved 'system' space:     $green$(($(sudo tune2fs -l $iID | grep -E Reserved.+count | awk '{print $4}') * $iblocksize / (1024*1024*1024) ))G
$orange                                                                         

________________________________________________________________________________________                    
$cyan
                         fs)$orange           Free up some space (internal drive)
$cyan
                       info)$orange           Reserved space info
$cyan
                         um)$orange           Unmount Parmanode external drive 
$cyan
                      mount)$orange           Mount Parmanode externl drive
$cyan
                       dfat)$orange           Drive format assist tool
$cyan 
                         md)$orange           Import/Migrate/Revert an external drive
$cyan
                         de)$orange           Drive encryption - info
$cyan
                         ps)$orange           Adjust SSD power saving

########################################################################################
"
choose xpmq ; read choice
jump $choice
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;
info)
announce "The reserved space on the drive is for drive recovery functionality. You
    can squeeze more space out of the drive by setting the reserve percentage to zero.

    It's not generally recommended because as the drive gets close to full, it's more
    prone to data corruption, so it's time to get a new drie anyway.

    To set it to zero, the command is... $cyan

        sudo tune2fs -m 0 drive_ID$orange

    The drive ID will be something like /dev/sda for example."
;;
um|UM|Um)
    safe_unmount_parmanode menu
;;
mount)
    mount_drive || return 1
    if mount | grep -q parmanode ; then
    announce "Drive mounted."
    fi
;;
dfat|DFAT)
    format_assist
;;
md|MD)
    menu_migrate
;;

de)
    drive_encryption
;;
fs)
    free_up_space
;;
ps)
    adjust_ssd_power_saving
;;
esac
}


function menu_drives_mac {
while true ; do
set_terminal ; echo -e "
########################################################################################$cyan
                                Parmanode Drive Menu$orange
########################################################################################
$red
This menu is trimmed down for Macs. 


$cyan
                         fs)$orange           Free up some space (internal drive)
$cyan
                         um)$orange           Unmount Parmanode external drive 
$cyan
                      mount)$orange           Mount Parmanode externl drive
$cyan
                       dfat)$orange           Drive format assist tool


########################################################################################
"
choose xpmq ; read choice
jump $choice
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;
fs)
    free_up_space
;;
    um|UM|Um)
    safe_unmount_parmanode menu
;;
mount)
    mount_drive || return 1
    if mount | grep -q parmanode ; then
    announce "Drive mounted."
    fi
;;
dfat|DFAT)
    format_assist
;;
esac
done
}