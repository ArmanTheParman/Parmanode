function unmount {
set_terminal
please_wait

if [[ $OS == "Linux" ]] ; then

        sudo umount $disk >$dn 2>&1 
       
        if echo $disk | grep -E '2$' ; then 
        sudo umount ${disk%2}1 >$dn 2>&1
        fi

        if echo $disk | grep -E '3$' ; then 
        sudo umount ${disk%3}2 >$dn 2>&1
        sudo umount ${disk%3}1 >$dn 2>&1
        fi

        if echo $disk | grep -E '4$' ; then 
        sudo umount ${disk%4}3 >$dn 2>&1
        sudo umount ${disk%4}2 >$dn 2>&1
        sudo umount ${disk%4}1 >$dn 2>&1
        fi

        sudo umount /media/$USER/parmanode* >$dn 2>&1
        debug "umount function, end"
        return 0
    fi


if [[ $OS == "Mac" ]] ; then
        if echo $disk | grep -E '[0-9]$' ; then
        diskutil umountDisk ${disk%[0-9]} >$dn 2>&1
        fi
        diskutil unmountDisk $disk  >$dn 2>&1
        diskutil unmountDisk parmanode >$dn 2>&1
        return 0
    fi
}
