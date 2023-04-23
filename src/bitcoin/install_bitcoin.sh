function install_bitcoin {

set_terminal

install_check "bitcoin-start" 
    #first check if Bitcoin has been installed
    return_value="$?"
    if [[ $return_value = "1" ]] ; then return 1 ; fi       #Bitcoin already installed

change_drive_selection \
    && log "bitcoin" "install - change drive selection function exit"
    # User has choice to change drive selection made when first installing Parmanode.
    # abort bitcoin installation if return 2 
    if [[ $? == 1 || $? == 2 ]] ; then return 1 ; fi

prune_choice ; if [ $? == 1 ] ; then return 1 ; fi
    # set $prune_value. Doing this now as it is related to 
    # the drive choice just made by the user. i
    # Use variable later for setting bitcoin.conf

make_bitcoin_directories 
    # make bitcoin directories in appropriate locations
    # installed entry gets made when parmanode/bitcoin directory gets made.
    # symlinks created (before Bitcoin core installed)

# Download bitcoin software
    if [[ $OS == "Linux" ]] ; then download_bitcoin_linux ; fi
    if [[ $OS == "Mac" ]] ; then download_bitcoin_mac ; fi

#setup bitcoin.conf
make_bitcoin_conf
        if  [ $? -ne 0 ]
            then return 1
        fi

#make a script that service file will use
if [[ $OS == "Linux" ]] ; then
make_mount_check_script ; fi

#make service file
if [[ $OS == "Linux" ]] ; then 
    make_bitcoind_service_file
fi

set_terminal
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core will begin syncing after a reboot, or you can start Bitcoin Core 
    from the Parmanode menu.

    You can also access Bitcoin functions from the Parmanode menu.
    

########################################################################################
" && installed_config_add "bitcoin-end"
enter_continue
return 0 
fi


set_terminal
if [[ $OS == "Mac" ]] ; then
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
enter_continue
return 0 
fi


debug "Unknown error. Aborting." ; enter_exit ; exit 1
}

