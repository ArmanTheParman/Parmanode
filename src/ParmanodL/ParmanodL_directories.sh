function ParmanodL_directories {

# Prepare directories
    if [[ ! -d $mnt ]] ; then sudo mkdir $mnt ; fi
	mkdir -p $HOME/ParmanodL 
	mkdir -p $HOME/.parmanode # Borrowing parmanode's config directory

    # if [[ $OS == Linux ]] ; then mkdir -p /tmp/mnt/raspi ; fi  		
	            #not needed for mac because mount point will be inside podman container.
}