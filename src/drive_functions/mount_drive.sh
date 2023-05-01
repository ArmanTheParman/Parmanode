function mount_drive {

if [[ $OS == "Mac" ]] ; then
if [[ $drive == "external" || $drive_fulcrum == "external" ]] ; then
    #if mounted, exit 
	    if mount | grep "parmanode" >/dev/null 2>&1 ; then
			return 0
			fi

    # If function didn't return 0, try mounting with label, then UUID, then loop.
		sleep 1
    	diskutil mount parmanode >/dev/null 2>&1 || { debug "Unable to mount disk. Aborting." ; return 1 ; }
		set_terminal
		return 0
		
fi
fi

########################################################################################

if [[ $OS == "Linux" ]] ; then
if [[ $drive == "external" || $drive_fulcrum == "external" ]] ; then
    #if mounted, exit 
	    if mountpoint -q "/media/$(whoami)/parmanode" ; then
			return 0
			fi

    # If function didn't return 0, try mounting with label, then UUID, then loop.

		#try mounting
        sleep 1

		sudo mount -L parmanode /media/$(whoami)/parmanode
			sleep 5
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		sudo mount -U $UUID
		 	sleep 5
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		set_terminal
		
		echo "Drive not mounted. Mounting ... Hit (q) to abort."
		read choice ; if [[ $choice == "q" ]] ; then return 1 ; fi

fi
fi
}