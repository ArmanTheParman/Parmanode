function install_electrs_docker {
# Docker container runs with tor daemon for CMD
# Starting electrs and nginx happens with a function call after container started.
# Data is synced to /electrs_db inside container.
# External drive sync is volume mounted directly to external drive
# Internal drive sync is mounted to $HOME/.electrs

unset install_electrs_docker
export install_electrs_docker=true # used later to fork make config code.

source $pc $ic >/dev/null 2>&1

grep -q "bitcoin-end" < $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

if ! which nginx ; then install_nginx || { announce "Trying to first install Nginx, something went wrong." \
"Aborting" ; return 1 ; } 
fi

grep -q "docker-end" < $dp/installed.conf || { announce "Please install Docker from Parmanode menu first. Aborting." && return 1 ; }

if [[ $OS == Mac ]] ; then announce "Please make sure docker is running at least in the background, or
    installation is likely to fail."
fi

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

install_jq

check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin=true
check_rpc_bitcoin
unset dontstartbitcoin

preamble_install_electrs_docker || return 1

set_terminal ; please_wait

docker build -t electrs $original_dir/src/electrs/ ; log "electrsdkr" "docker build done"
debug "check build for errors"
installed_config_add "electrsdkr2-start"


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
      mkdir -p $parmanode_drive/electrs_db
      sudo chown -R $USER $parmanode_drive/electrs_db >/dev/null 2>&1

fi
debug "before prepare_dirve_electrs"
prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } 
debug "pause after prepare_drive_electrs"
#if it exists, test inside function
restore_internal_electrs_db || return 1
debug "after restore internal electrs db"
#config
########################################################################################
make_electrs_config && log "electrs" "config done" 
debug "pause after config"

#Start the container
docker_run_electrs || { announce "failed to run docker electrs" ; log "electrsdkr" "failed to run" ; return 1 ; }
debug "after docker run electrs"

#Set permissions
docker exec -itu root electrs bash -c "chown -R parman:parman /home/parman/parmanode/electrs/"
debug "pause after run and chown"

#Nginx
make_ssl_certificates electrsdkr
electrs_nginx electrsdkr

#Run electrs and Nginx in the container
docker_start_electrs || return 1 
debug "pause after start"

installed_config_add "electrsdkr2-end"
unset install_electrs_docker
success "electrs in Docker" "being installed"

}
