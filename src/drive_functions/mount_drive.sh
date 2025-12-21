function mount_drive {

if [[ $OS == "Mac" ]] ; then

    #if mounted, exit 
	    if mount | grep "parmanode" >$dn 2>&1 ; then
			return 0
			fi

    # If function didn't return 0, try mounting with label, then UUID, then loop.
		sleep 1
    	diskutil mount parmanode >$dn 2>&1 || { debug "Unable to mount disk. Aborting." ; return 1 ; }
		set_terminal
		return 0

fi


if [[ $OS == "Linux" ]] ; then

        if [[ $parmaview == 1 ]] ; then
            sudo /usr/local/parmanode/p4run "mount_parmanode" #anticipates that fstab entry exists
			return $?
        fi

while true ; do
    #if mounted, exit 
	    if mountpoint -q "/media/$USER/parmanode" ; then
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
		
		echo -e "Drive not mounted.$cyan <enter>$orange to try again. Hit$red q$orange to abort."
		read choice ; if [[ $choice == "q" ]] ; then return 1 ; fi
done
fi
}