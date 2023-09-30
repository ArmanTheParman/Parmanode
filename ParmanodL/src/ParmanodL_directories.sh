function ParmanodL_directories {
# Prepare working directories

	mkdir -p $HOME/ParmanodL 
	mkdir -p $HOME/.parmanode
	mkdir -p $HOME/.parmanodl
	touch -p $HOME/.parmanodl/parmanodl.conf
	touch -p $HOME/.parmanodl/installed.conf
    if [[ $OS == Linux ]] ; then mkdir -p /tmp/mnt/raspi ; fi  

}