function menu_external_drive {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! mount | grep -q parmanode ; then 
    announce "No parmanode labelled drive seems to be mounted. Aborting."
    return 0
fi

if [[ $(mount | grep parmanode | wc -l | awk '{print $1}') != 1 ]] ; then #awk redundant for Linux but makes it work on Mac
    announce "More than one parmanode drive seems to be mounted. Aborting."
    return 1
fi
ID=$(mount | grep parmanode | awk '{print $1}')
blocksize=$(sudo tune2fs -l $ID | grep -E 'Block size' | awk '{print $3}')

set_terminal ; echo -e "
########################################################################################$cyan
                              Parmanode Drive Menu$orange
########################################################################################

$orange                                                                         
                    Drive device ID:             $green$(mount | grep parmanode | awk '{print $1}')
$orange                                                        
                    Total space:                 $green$(df -h | grep $ID | awk '{print $2}')
$orange
                    Free space:                  $green$(df -h | grep $ID | awk '{print $4}')
$orange
                    Label:                       $green$(e2label $ID)
$orange
                    UUID:                        $green$(sudo tune2fs -l $ID | grep UUID | awk '{print $3}')
$orange
                    Mountpoint:                  $green$(mount | grep $ID | awk '{print $3}')
$orange
                    Reserved 'system' space:     $green$(($(sudo tune2fs -l $ID | grep -E Reserved.+count | awk '{print $4}') * $blocksize / (1024*1024*1024) ))G
$orange

________________________________________________________________________________________                    
$red

                    info)$orange                        Reserved space info
                    

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
esac
}


