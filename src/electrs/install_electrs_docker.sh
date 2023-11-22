function install_electrs_docker {

source $parmanode_conf >/dev/null 2>&1

grep -q "bitcoin-end" < $dp/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

if ! which nginx ; then install_nginx || { announce "Trying to first install Nginx, something went wrong." \
"Aborting" ; return 1 ; } 
fi

grep -q "docker-end" < $dp/installed.conf || { announce "Please install Docker from Parmanode menu first. Aborting." && return 1 ; }

# check Bitcoin settings
unset rpcuser rpcpassword prune server
source $HOME/.bitcoin/bitcoin.conf >/dev/null
check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin=true
check_rpc_bitcoin
unset dontstartbitcoin




preamble_install_electrs_docker || return 1

set_terminal ; please_wait

docker build -t electrs $original_dir/src/electrs/ ; log "electrsdkr" "docker build done"

installed_config_add "electrsdkr-start"

make_ssl_certificates ; log "electrsdkr" "make ssl certs done"
# electrs_nginx add

#prepare drives
choose_and_prepare_drive "Electrs" && log "electrsdkr" "choose and prepare drive function borrowed"

source $HOME/.parmanode/parmanode.conf >/dev/null

if [[ ($drive_electrs == "external" && $drive == "external") || \
      ($drive_electrs == "external" && $drive_fulcrum == "external") ]] ; then 
    # format not needed
    # Get user to connect drive.
      pls_connect_drive || return 1 

    # check if there is a backup electrs_db on the drive and restore it
      restore_elctrs_drive #prepares drive based on existing backup and user choices
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_electrs_drive
elif [[ $drive_electrs == exteranal ]] ; then

      format_ext_drive "electrs" || return 

fi

prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } 
debug "prepare drive done"

#if it exists, test inside function
restore_internal_electrs_db || return 1

#config
########################################################################################
make_electrs_config && log "electrs" "config done" 

debug "pre run electrs. check directories"
docker_run_electrs || { announce "failed to run docker electrs" ; log "electrsdkr" "failed to run" ; return 1 ; }
debug "2"
docker_start_electrs || return 1
debug "3"
installed_config_add "electrsdkr-end"
debug "4"
success "electrs" "being installed"

}
