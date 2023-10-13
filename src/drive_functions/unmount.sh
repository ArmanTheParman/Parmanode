function unmount {
set_terminal
echo " 
Please wait a few seconds for the drive to unmount ... 
"
sleep 2 # causes code to pause 2 seconds. Allows message to be seen without
        # need for user input (ie no enter_continue)

if [[ $OS == "Linux" ]] ; then
        
        sudo umount $disk* >/dev/null 2>&1 
        sudo umount /media/$USER/parmanode* >/dev/null 2>&1
        debug "umount function, exiting..."
        return 0
    fi


if [[ $OS == "Mac" ]] ; then
        diskutil unmountDisk $disk  >/dev/null 2>&1
        diskutil unmountDisk parmanode >/dev/null 2>&1
        return 0
    fi
}
