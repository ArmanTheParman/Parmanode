function install_electrs {

grep -q "bitcoin-end" < "$HOME/.parmanode/installed.conf" >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
if ! which nginx ; then install_nginx || { announce "Trying to first install Nginx, something went wrong." \
"Aborting" ; } 
fi

unset electrs_compile && restore_electrs #get electrs_compile true/false

if [[ $electrs_compile == "false" ]] ; then 

    please_wait rm -rf $HOME/parmanode/electrs/ 
    mv $HOME/.electrs_backup $HOME/parmanode/electrs

    installed_config_add "electrs-start"

else #if [[ $electrs_compile == "true" ]] ; then

    preamble_install_electrs || return 1

    set_terminal ; please_wait

    build_dependencies_electrs || return 1 
            log "electrs" "build_dependencies finished" 
    download_electrs && log "electrs" "download_electrs success" 
            debug "download electrs done"
    compile_electrs || return 1 
            log "electrs" "compile_electrs done" ; debug "build, download, compile... done"

fi

#remove old certs (in case they were copied from backup), then make new certs
rm $HOME/parmanode/electrs/*.pem > /dev/null 2>&1
{ make_ssl_certificates "electrs" && debug "check certs for errors " ; } || announce "SSL certificate generation failed. Proceed with caution." ; debug "ssl certs done"

electrs_nginx add

# check Bitcoin settings
unset rpcuser rpcpassword prune server
source $HOME/.bitcoin/bitcoin.conf >/dev/null
check_pruning_off || return 1
check_server_1 || return 1
check_rpc_bitcoin

#prepare drives
choose_and_prepare_drive_parmanode "Electrs" && log "electrs" "choose and prepare drive function borrowed"

source $HOME/.parmanode/parmanode.conf >/dev/null

if [[ $drive_electrs == "external" && $drive == "external" || $drive_fulcrum == "external" ]] ; then 
    # format not needed
    # check if there is a backup electrs_db on the drive and restore it
      restore_elctrs_drive #prepares drive based on existing backup and user choices
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$USER $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_electrs_drive
else
      format_ext_drive "electrs" || return 
fi

prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } 
        debug "prepare drive done"


#config
make_electrs_config && log "electrs" "config done" ; debug "config done"

if [[ $OS == Linux ]] ; then make_electrs_service || log "electrs" "service file failed" ; debug "service file done" ; fi

installed_config_add "electrs-end" ; debug "finished electrs install"

success "electrs" "being installed"

if [[ $electrs_compile == "true" ]] ; then
    backup_electrs
fi

}

########################################################################################

function check_pruning_off {
    if [[ $prune -gt 0 ]] ; then
    announce "Note that Electrs won't work if Bitcoin is pruned. You'll have to" \
    "completely start bitcoin sync again without pruning to use Electrs. Sorry."
    return 1
    else
    return 0
    fi
}

function check_server_1 {
if [[ $server -ne 1 ]] ; then 
announce "\"server=1\" needs to be included in the bitcoin.conf file." \
"Please do that and try again. Aborting." 
return 1 
fi
}


