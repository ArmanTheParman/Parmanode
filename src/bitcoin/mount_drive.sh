function mount_drive {

    #if mounted, make .bitcoin and exit 0
	    if mountpoint -q "/media/$(whoami)/parmanode" ; then
		mkdir /media/$(whoami)/parmanode/.bitcoin > /dev/null 2>&1 
		# potentially redundant depending on which function calls but no harm if the directory exits.
		return 0

    # Otherwise, try mounting with label, then UUID, then loop.
	    else
		set_terminal
		echo "Drive not mounted. Mounting ... Hit (q) to abort."
		read choice ; if [[ $choice == "q" ]] ; then return 1 ; fi

		#try mounting
		sudo mount -L parmanode /media/$(whoami)/parmanode
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		sudo mount -U $UUID
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0
			else sleep 3 ; debug_point "about to loop into mount drive " ; mount_drive ; fi  #calling self (loop)
	    fi

return 0
}
