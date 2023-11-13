function install_electrs_docker {

source $parmanode_conf >/dev/null 2>&1

grep -q "bitcoin-end" < $HOME/.parmanode/installed.conf || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

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

isbitcoinrunning
if [[ $running == true ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################

    Bitcoin needs to be stopped when electrs is being stalled. Shall Parmanode
    stop it for you? 

               y)       Stops Bitcoin Core for now

               n)       Leave Bitcoin Core running, aborts electrs install

########################################################################################  
"
choose "xpmq"
read choice ; set_terminal
case $choice in
q|Q) exit ;;
p|P) return 1 ;;
n|N) return 1 ;;
m|M) back2main ;; 
y|Y) stop_bitcoind ; break ;;
*) invalid ;;
esac
done
fi #and if bitcoin running


installed_config_add "electrsdkr-start"


preamble_install_electrs_docker || return 1

    set_terminal ; please_wait
    #variables from parmanode.conf


docker build -t electrs $original_dir/src/electrs/

make_ssl_certificates
# electrs_nginx add

#prepare drives
choose_and_prepare_drive "Electrs" && log "electrs" "choose and prepare drive function borrowed"

source $HOME/.parmanode/parmanode.conf >/dev/null

if [[ ($drive_electrs == "external" && $drive == "external") || \
      ($drive_electrs == "external" && $drive_fulcrum == "external") ]] ; then 
    # format not needed
    # Get user to connect drive.
      pls_connect_drive || return 1 

    # check if there is a backup electrs_db on the drive and restore it
      restore_elctrs_drive #prepares drive based on existing backup and user choices
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$USER $original > /dev/null 2>&1 ; fi
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
make_electrs_config && log "electrs" "config done" ; debug "config done"


docker_run_electrs
docker_start_electrs

installed_config_add "electrsdkr-end"

success "electrs" "being installed"

}
