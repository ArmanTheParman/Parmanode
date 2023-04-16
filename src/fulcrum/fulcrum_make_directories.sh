function fulcrum_make_directories {

# Make parmanode/fulcrum directory on internal drive
mkdir $HOME/parmanode/fulcrum >/dev/null 2>&1 && \
installed_config_add "fulcrum-start"

if [[ $drive_fulcrim == "external" ]] ; then

set_terminal ; echo "
########################################################################################

                        Please connect drive then hit <enter> 

########################################################################################
"
enter_continue ; mount_drive && log "fulcrum" "Drive mounted."

mkdir /media/$(whoami)/parmanode/fulcrum_db >/dev/null 2>&1 || log "fulcrum" "mkdir fulcrum_db on ext drive failed."

return 0
}

