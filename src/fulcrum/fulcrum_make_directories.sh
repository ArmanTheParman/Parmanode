function fulcrum_make_directories {

# Make parmanode/fulcrum directory on internal drive
    mkdir $HOME/parmanode/fulcrum >/dev/null 2>&1 && \
    installed_config_add "fulcrum-start"




# Make fulcrum_db on the internal or external drive

if [[ $drive_fulcrum == "external" ]] ; then

set_terminal ; echo "
########################################################################################

                        Please connect drive then hit <enter> 

########################################################################################
"
enter_continue ; mount_drive && log "fulcrum" "Drive mounted."

case $OS in
    Linux) mkdir /media/$(whoami)/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db made - external" && return 0 ;;
    Mac ) mkdir /Volumes/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db made - external" && return 0 ;;
    *) log "fulcrum" "mkdir fulcrum_db on ext drive failed."    
       debug "Failed to make fulcrum_db. Continue with caution." 
       return 1 ;;
    esac
fi




if [[ $drive_fulcrum == "internal" ]] ; then
    
    { mkdir $HOME/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db made - internal" ; } || \
    { debug "mkdir fulcrum_db on internal drive failed. Continue with caution." && return 1 ; } 
    return 0
    fi
}

