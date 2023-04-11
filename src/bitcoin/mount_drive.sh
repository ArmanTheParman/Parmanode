function mount_drive {

    #if mounted, make .bitcoin and exit 0
	    if mountpoint -q "/media/$(whoami)/parmanode" ; then
			mkdir /media/$(whoami)/parmanode/.bitcoin > /dev/null 2>&1 
			# potentially redundant depending on which function calls but no harm if the directory exits.
			return 0
			fi

    # If function didn't return 0, try mounting with label, then UUID, then loop.

		#try mounting
        sleep 1

		sudo mount -L parmanode /media/$(whoami)/parmanode
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		sudo mount -U $UUID
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		set_terminal
		
		echo "Drive not mounted. Mounting ... Hit (q) to abort."
		read choice ; if [[ $choice == "q" ]] ; then return 1 ; fi

return 0
}
