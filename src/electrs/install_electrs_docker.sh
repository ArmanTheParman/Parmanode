function install_electrs_docker {
unset install_electrs_docker
export install_electrs_docker=true # used later to fork make config code.

source $pc $ic >/dev/null 2>&1

grep -q "electrs-" < $ic && announce "Oops, you're trying to install a second instance of electrs.
    It seems you alread have a non-Docker version of electrs installed 
    on the system. Parmanode cannot install the Docker version of electrs 
    if the Docker version is already installed. Bad things can happen. 
    Aborting." && return 1   

grep -q "bitcoin-end" < $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

if ! which nginx ; then install_nginx || { announce "Trying to first install Nginx, something went wrong." \
"Aborting" ; return 1 ; } 
fi

grep -q "docker-end" < $dp/installed.conf || { announce "Please install Docker from Parmanode menu first. Aborting." && return 1 ; }

# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >/dev/null
else
clear
echo "The bitcoin.conf file could not be detected. Can heppen if Bitcoin is
supposed to sync to the external drive and it is not connected and mounted.
Hit <enter> to try again once you connect the drive."
fi
if [[ ! -e $bc ]] ; then
announce "Couldn't detect bitcoin.conf - Aborting."
return jb1 
fi

check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin=true
check_rpc_bitcoin
unset dontstartbitcoin


preamble_install_electrs_docker || return 1

set_terminal ; please_wait

docker build -t electrs $original_dir/src/electrs/ ; log "electrsdkr" "docker build done"
debug "check build for errors"
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
      debug "after restore_electrs_drive"
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_electrs_drive
elif [[ $drive_electrs == external ]] ; then

      format_ext_drive "electrs" || return 
      #make directory electrs_db not needed because config file makes that hapen when electrs run
      mkdir -p $pamranode_drive/electrs_db

fi

prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } 
debug "pause after prepare_drive_electrs"
#if it exists, test inside function
restore_internal_electrs_db || return 1

#config
########################################################################################
make_electrs_config && log "electrs" "config done" 
debug "pause after config"
docker_run_electrs || { announce "failed to run docker electrs" ; log "electrsdkr" "failed to run" ; return 1 ; }
docker exec -itu root electrs bash -c "chown -R /home/parman/electrs/"
debug "pause after run"
docker_start_electrs || return 1
debug "pause after start"
installed_config_add "electrsdkr-end"
unset install_electrs_docker
success "electrs" "being installed"

}
