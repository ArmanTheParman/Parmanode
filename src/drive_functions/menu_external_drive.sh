function menu_external_drive {

if [[ $OS == "Mac" ]] ; no_mac ; return 1 ; fi

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
                    Reserved 'system' space:     $green$(($(sudo tune2fs -l $ID | grep -E Reserved.+count | awk '{print $4}') * $blocksize / (1024*1024*1024) ))G
$orange
                    Label:                       $green$(e2label $ID)
$orange
                    UUID:                        $green$(sudo tune2fs -l $ID | grep UUID | awk '{print $3}')
$orange
                    Mountpoint:                  $green$(mount | grep $ID | awk '{print $3}')
$orange

########################################################################################
"
enter_continue


}