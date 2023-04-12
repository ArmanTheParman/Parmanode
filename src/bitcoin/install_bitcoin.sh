function install_bitcoin {

set_terminal

install_check "bitcoin-start" 
    #first check if Bitcoin has been installed
    return_value="$?"
    if [[ $return_value = "1" ]] ; then return 1 ; fi       #Bitcoin already installed

change_drive_selection
    # abort bitoin installation if return 1
    if [[ $? == 1 ]] ; then return 1 ; fi


prune_choice 
    # set $prune_value. Doing this now as it is related to 
    # the drive choice. Use variable later for setting bitcoin.conf

make_bitcoin_directories $drive         
    # make bitcoin directories in appropriate locations
    # external or internal argument
    # installed entry made when parmanode/bitcoin directory made.

download_bitcoin

#setup bitcoin.conf
make_bitcoin_conf
    if  [ $? -ne 0 ]
        then return 1
    fi

#make a script that service file will use
make_mount_check_script

#make service file
make_bitcoind_service_file
if [ $? == 1 ] ; then return 1 ; fi

set_terminal

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
}

