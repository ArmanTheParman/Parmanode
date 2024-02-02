function fulcrum_success_install {

set_terminal ; echo -e "
########################################################################################
   $cyan 
                                    SUCCESS !!!
$orange
    Fulcrum will begin running, but won't actually start syncing until Bitcoin has
    made some progress syncing itself.

########################################################################################
" && installed_config_add "fulcrum-end" && log "fulcrum" "install finished"
enter_continue
}