function fulcrum_success_install {

set_terminal ; echo "
########################################################################################
    
                                    SUCCESS !!!

    Fulcrum will begin running, but won't actually start syncing until Bitcoin has
    made some progress syncing itself.

    Remember to reboot Bitcoin if you changed the RPC password during this install.

    Note: Fulcrum will not sync unless Bitcoin Core has a username and password
    set. Parmanode has attempted to copy these values into Fulcrum's configuration
    file.

########################################################################################
" && installed_config_add "fulcrum-end" && log "fulcrum" "install finished"
enter_continue
}