function unmount {
set_terminal
echo " 
Please wait a few seconds for the drive to unmount ... 
"
sleep 2 # causes code to pause 2 seconds. Allows message to be seen without
        # need for user input (ie no enter_continue)

if [[ $OS == "Linux" ]] ; then
        
        # if the $disk variable is set, typically during drive preparation,
        # then this umount procedure will work and umount the correct drive.
        # At other times, the variable is empty so nothing will be unmounted.
        for i in $( sudo lsblk -nrpo NAME /dev/$disk )
        do 
            sudo umount $i >/dev/null 2>&1 
            done 
        # If the parmanode drive needs to be unmounted...
        sudo umount /media/$USER/parmanode >/dev/null 2>&1
        return 0
    fi


if [[ $OS == "Mac" ]] ; then
        diskutil unmountDisk $disk  >/dev/null 2>&1
        diskutil unmountDisk parmanode >/dev/null 2>&1
        return 0
    fi
}
