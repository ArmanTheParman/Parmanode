function install_bitcoin {
this_install="$1"

set_terminal

if [[ "$this_install" != "docker" ]] ; then
install_check "bitcoin" 
    #first check if Bitcoin has been installed
    return_value="$?"
    if [[ $return_value == "1" ]] ; then
        log "bitcoin" "install_check return 1, exit" ; return 1 ; fi      
else
install_check "btc_docker"
    return_value="$?"
    if [[ $return_value == "1" ]] ; then
        log "btc_docker" "install_check return 1, exit" ; return 1 ; fi      
fi




change_drive_selection \
    && log "bitcoin" "install - change drive selection function exit"
    # User has choice to change drive selection made when first installing Parmanode.
    # abort bitcoin installation if return 2 
    if [[ $? == 1 || $? == 2 ]] ; then 
    log "bitcoin" "change_drive_selection return 1 or 2; exit" ; return 1 ; fi

#Just in case
    if [[ $OS == "Linux" && $drive == "external" ]] ; then
        sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1 \
        && log "bitcoin" "chown applied in install_bitcoin function" \
        || log "bitcoin" "unable to execute chown in intstall_bitcoin function" ; fi


log "bitcoin" "prune choice function..." && \
    prune_choice ; if [ $? == 1 ] ; then return 1 ; fi
    # set $prune_value. Doing this now as it is related to 
    # the drive choice just made by the user. i
    # Use variable later for setting bitcoin.conf

log "bitcoin" "make_bitcoin_directories function..." && \
    make_bitcoin_directories 
    # make bitcoin directories in appropriate locations
    # installed entry gets made when parmanode/bitcoin directory gets made.
    # symlinks created (before Bitcoin core installed)
    #Just in case
            if [[ $OS == "Linux" && $drive == "external" ]] ; then
            sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1 && \
            statement=$(ls -dlah /media/$(whoami)/parmanode) && \
            log "bitcoin" "bitcoin chown run again" && \ 
            log "bitcoin" "ownership statement: $statement" ; fi

# Download bitcoin software
    while true ; do
    if [[ $this_install == "docker" ]] ; then
        install_check "docker" "installed_return=0" 
        if [[ $? == 1 ]] ; then install_docker ; fi        	
        if ! command -v docker ; then start_docker_mac ; fi 
        docker build -t bitcoin . || errormessage
        break 
        fi
    if [[ $OS == "Linux" ]] ; then log "bitcoin" "download function Linux..." && download_bitcoin_linux ; break ; fi
    if [[ $OS == "Mac" ]] ; then log "bitcoin" "download function Mac..." && download_bitcoin_mac ; break ; fi
    done

#setup bitcoin.conf
log "bitcoin" "make_bitcoin_conf function ..."
make_bitcoin_conf
        if  [ $? -ne 0 ]
            then return 1
        fi

if [[ $this_install != "docker" ]] ; then 

	#make a script that service file will use
	if [[ $OS == "Linux" ]] ; then
	make_mount_check_script ; fi

	#make service file
	if [[ $OS == "Linux" ]] ; then 
	    make_bitcoind_service_file
	fi
fi

set_terminal
if [[ $OS == "Linux" && $this_install != "docker" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core will begin syncing after a reboot, or you can start Bitcoin Core 
    from the Parmanode Bitcoin menu.

    You can also access Bitcoin functions from the Parmanode menu.
    

########################################################################################
" && installed_config_add "bitcoin-end"

#Just in case
    sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
return 0 
fi


set_terminal
if [[ $OS == "Mac" && $this_install != "docker" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core can begin syncing once you select \"START\" from the Bitcoin menu
    found under the \"Run Parmanode\" menu. You can also watch it fly if you select
    to observe the debug file (same menu).
    
    For now, I have not created a Mac service file to automatically make Bitcoin Core 
    start after a reboot, as it seemed to introduce too much potential for error. 

    Do remmember to manually restart Bitcoin should your computer power off. 

########################################################################################
" && installed_config_add "bitcoin-end"
    #Just in case
            sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
return 0 
fi

set_terminal
if [[ $this_install == "docker" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core will run in the Docker container. The data will be written external
    to the container. That is, if you chose an external drive, it will be written
    there. But if you chose an internal drive, it will be written there on the disk,
    not in the docker container. You can theoretically switch drives around (while
    the container is stopped), but do make sure you keep backups, as unpredictable
    things can happen, and I've experienced blockchain data corruption doing that.
    Starting again, without a backup drive is no fun.


########################################################################################
" && installed_config_add "btc_dockern-end"
    #Just in case
            sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode >/dev/null 2>&1

enter_continue
return 0 
fi


debug "Unknown error. Aborting." ; enter_exit ; exit 1
}

