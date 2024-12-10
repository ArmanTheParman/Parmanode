function menu_external_drive {

if ! mount | grep -q parmanode ; then 
    return 0
fi

if [[ $(mount | grep parmanode | wc -l) != 1 ]] ; then
    announce "More than one parmanode drive seems to be mounted. Aborting."
    return 1
fi
ID=$(mount | grep parmanode | awk '{print $1}')
blocksize=$(sudo tune2fs -l $ID | grep -E 'Block size' | awk '{print $3}')

set_terminal ; echo -e "
########################################################################################$cyan
                              Parmanode Drive Menu$orange
########################################################################################

                                                                         
                    Drive device ID:             $green$(mount | grep parmanode | awk '{print $1}')
                                                        
                    Total space:                 $green$(df -h | grep $ID | awk '{print $2}')

                    Free space:                  $green$(df -h | grep $ID | awk '{print $4}')

                    Reserved 'system' space:     $green$(($(sudo tune2fs -l $ID | grep -E Reserved.+count | awk '{print $4}') * $blocksize / (1024*1024*1024) ))G

                    Label:                       $green$(e2label $ID)

                    UUID:                        $green$(sudo tune2fs -l $ID | grep UUID | awk '{print $3}')

                    Mountpoint:                  $green$(mount | grep $ID | awk '{print $3}')


########################################################################################
"
enter_continue


}