function fulcrum_success_install {


if [[ $OS == "Linux" ]] ; then
set_terminal ; echo "
########################################################################################
    
                                    SUCCESS !!!

    Fulcrum will begin syncing after a reboot, but only if Bitcoin Core has finished
    syncing. You can also start Fulcrum from the Parmanode menu.

    Remember to reboot Bitcoin if you changed the RPC password during this install.

########################################################################################
" && installed_config_add "fulcrum-end" && log "fulcrum" "install finished"
enter_continue
fi



if [[ $OS == "Mac" ]] ; then
set_terminal ; echo "
########################################################################################
    
                                    SUCCESS !!!

    Fulcrum can now be started from the Parmanode menu. I can begin syncing even
    before Bitcoin has finished syncing, but it's probably better to wait for Bitcoin
    to sync up first.

    Remember to reboot Bitcoin if you changed the RPC password during this install.

########################################################################################
" && installed_config_add "fulcrum-end" && log "fulcrum" "install finished"
enter_continue
fi

}