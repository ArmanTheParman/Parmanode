function install_electrs_docker {

# Docker container runs with tor daemon for CMD
# Data is synced to /electrs_db inside container.
# External drive sync is volume mounted directly to external drive
# Internal drive sync is mounted to $HOME/.electrs

unset install_electrs_docker_variable
export install_electrs_docker_variable="true" # used later to fork make config code.

source $pc $ic >/dev/null 2>&1

grep -q "bitcoin-end" $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

grep -q "docker-end" $dp/installed.conf || { announce "Please install Docker from Parmanode menu first. Aborting." && return 1 ; }

if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi

#use socat inside container instead
    # if [[ $OS == Linux ]] ; then
    #     if ! which socat >/dev/null ; then sudo apt-get update -y ; sudo apt install socat -y ; fi
    # elif [[ $OS == Mac ]] ; then 
    #     brew_check || return 1 
    #     brew install socat 
    # fi


#socat put inside the container.
    # #going with service file instead for now
    # #make_socat_script electrs
    # if [[ $OS == Linux ]] ; then
    # make_socat_service_listen
    # make_socat_service_publish
    # fi

# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >/dev/null
else
clear
announce "The bitcoin.conf file could not be detected. Can happen if Bitcoin is
    supposed to sync to the external drive and it is not connected and mounted.
    Aborting."
return 1
fi

if ! which jq >/dev/null ; then install_jq ; fi

check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin="true"
check_rpc_bitcoin
unset dontstartbitcoin

preamble_install_electrs_docker || return 1

set_terminal ; please_wait

docker build -t electrs $pn/src/electrs/ ; log "electrsdkr" "docker build done"
echo -e " $red
Pausing here; you can see if the build failed or not."
enter_continue
installed_config_add "electrsdkr2-start"


#prepare drives
choose_and_prepare_drive "Electrs" || return 1
source $pc >/dev/null

if [[ $drive_electrs == external ]] && grep "=external" $pc | grep -vq "electrs" ; then #don't grep 'external' alone, too ambiguous
    # format not needed
    # Get user to connect drive.
      pls_connect_drive || return 1 

    # check if there is a backup electrs_db on the drive and restore it
      restore_electrs_drive #prepares drive based on existing backup and user choices
      debug "after restore_electrs_drive"
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_electrs_drive
elif [[ $drive_electrs == external ]] ; then

      if [[ -d $pd/electrs_db ]] ; then drive_ready="true" ; fi

      case $drive_ready in
      true)
      unset drive_ready
      ;;
      *)
      format_ext_drive "electrs" || return 
      #make directory electrs_db not needed because config file makes that hapen when electrs run
      mkdir -p $parmanode_drive/electrs_db
      sudo chown -R $USER $parmanode_drive/electrs_db >/dev/null 2>&1
      esac

fi

debug "before prepare_dirve_electrs"
prepare_drive_electrs 
#if it exists, test inside function
if [[ $drive_electrs == internal ]] ; then
restore_internal_electrs_db || return 1 
fi

#config
########################################################################################
make_electrs_config && log "electrs" "config done" 

#Start the container
docker_run_electrs || { announce "failed to run docker electrs" ; log "electrsdkr" "failed to run" ; return 1 ; }
debug "after docker run electrs"

#Set permissions
docker exec -itu root electrs bash -c "chown -R parman:parman /home/parman/parmanode/electrs/"

make_ssl_certificates electrsdkr || announce "SSL certificate generation failed. Proceed with caution."  ; debug "check ssl certs done"

docker_start_electrs || return 1 

installed_config_add "electrsdkr2-end"
unset install_electrs_docker_variable
success "electrs in Docker" "being installed"

}
