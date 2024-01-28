function unmount {
set_terminal
please_wait

if [[ $OS == "Linux" ]] ; then
        
        sudo umount $disk* >/dev/null 2>&1 
        sudo umount /media/$USER/parmanode* >/dev/null 2>&1
        debug "umount function, end"
        return 0
    fi


if [[ $OS == "Mac" ]] ; then
        diskutil unmountDisk $disk  >/dev/null 2>&1
        diskutil unmountDisk parmanode >/dev/null 2>&1
        return 0
    fi
}
