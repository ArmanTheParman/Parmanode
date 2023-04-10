function unmount {
set_terminal
echo " 
Please wait a few seconds for the drive to unmount ... 
"
sleep 2

if [[ $OS == "Linux" ]] ; then

        { for i in $(sudo lsblk -nrpo NAME /dev/sdb) ; do sudo umount $i >/dev/null 2>&1 ; done } && { sleep 2 && set_terminal && return 0 }
        #redunant but harmless...
        { sudo umount /dev/$disk >/dev/null 2>&1 } && { sleep 2 && set_terminal && return 0 }


    echo "Encountered unexpected error when unmounting drive. Aborting."
    enter_continue
    exit 1
    fi


if [[ $OS == "Mac" ]] ; then

        diskutil unmountDisk && return 0
        sleep 2
        diskutil unmountDisk && return 0

    echo "Encountered unexpected error when unmounting drive. Aborting."
    enter_continue
    exit 1
    fi

debug_point "function failed" ; exit 1
}
