function fulcrum_success_install {
    
set_terminal ; echo "
########################################################################################
    
                                    SUCCESS !!!

    Fulcrum will begin syncing after a reboot, but only if Bitcoin Core has finished
    syncing. You can also start Fulcrum from the Parmanode menu.

########################################################################################
" && installed_config_add "fulcrum-end" && log "fulcrum" "install finished"
enter_continue
return 0 
}