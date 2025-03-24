function install_electrs_podman {

# Docker container runs with tor daemon using podmanfile CMD
# Data is synced to /electrs_db inside container.
# External drive sync is volume mounted directly to external drive
# Internal drive sync is mounted to $HOME/.electrs_db

unset install_electrs_podman_variable
export install_electrs_podman_variable="true" # used later to fork make config code.

source $pc $ic >$dn 2>&1

grep -q "bitcoin-end" $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

grep -q "podman-end" $dp/installed.conf || { announce "Please install Docker from Parmanode menu first. Aborting." && return 1 ; }

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi

mac_m3_electrs_warning

# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >$dn 
else
clear
announce "The bitcoin.conf file could not be detected. Can happen if Bitcoin is
    supposed to sync to the external drive and it is not connected and mounted.
    Aborting."
return 1
fi

if ! which jq >$dn ; then install_jq ; fi

check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin="true"
check_rpc_bitcoin
unset dontstartbitcoin

preamble_install_electrs_podman || return 1

set_terminal ; please_wait

podman build -t electrs $pn/src/electrs/ ; log "electrsdkr" "podman build done"
echo -e " $red
Pausing here; you can see if the build failed or not."
enter_continue
installed_config_add "electrsdkr2-start"


#prepare drives
choose_and_prepare_drive "Electrs" || return 1
source $pc >$dn

if [[ $drive_electrs == external ]] ; then

      if [[ -d $pd/electrs_db ]] ; then 
      true
      else
          if ! mount | grep -q $dp ; then
              format_ext_drive "electrs" || return 1
          fi
      mkdir -p $pd/electrs_db
      sudo chown -R $USER $parmanode_drive/electrs_db >$dn 2>&1
      fi
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
podman_run_electrs || { announce "failed to run podman electrs" ; log "electrsdkr" "failed to run" ; return 1 ; }
debug "after podman run electrs"

#Set permissions
podman exec -itu root electrs bash -c "chown -R parman:parman /home/parman/parmanode/electrs/"

make_ssl_certificates electrsdkr || announce "SSL certificate generation failed. Proceed with caution."  ; debug "check ssl certs done"

podman_start_electrs || return 1 

installed_config_add "electrsdkr2-end"
unset install_electrs_podman_variable
success "electrs in Docker" "being installed"

}

function mac_m3_electrs_warning {
if [[ $(uname -m) != "arm64" ]] ; then return 0 ; fi
set_terminal ; echo -e "
########################################################################################

    If you're using a computer with an ARM chip, ie a Pi or Mac M1 M2 or M3, this 
    method of installing electrs (with Docker)$cyan may$orange not work.

    Give it a go, but if it fails, you'll need to uninstall the failed partial 
    install, then try installing electrs directly without Docker.

########################################################################################
"
enter_continue ; jump $enter_cont

}