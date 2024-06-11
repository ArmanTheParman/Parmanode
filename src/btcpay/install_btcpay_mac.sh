function install_btcpay_mac {
export dockerfile="true"

if [[ $debug != 1 ]] ; then
grep "bitcoin-end" $HOME/.parmanode/installed.conf >/dev/null || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
fi

btcpay_mac_remove_bitcoin || return 1

set_terminal
if [[ "$1" != "resume" ]] ; then #btcpay-half flag triggers run_parmanode to start this function with "resume" flag
{
    sned_sats

    if ! command -v docker >/dev/null 2>&1 ; then

        need_docker_for_btcpay || return 1  #docker="no" or docker="yes" set

        if [[ $docker == "yes" ]] ; then install_docker_mac "btcpay" || return 1 ; fi 

    fi
}
else
installed_config_remove "btcpay-half"
set_terminal ; echo "Resuming BTCPay install" ; enter_continue
fi

if [[ $OS == "Mac" ]] ; then 
    if ! docker ps >/dev/null 2>&1 ; then start_docker_mac ; fi
fi

choose_btcpay_version || return 1

if [[ $dockerfile != "true" ]] ; then
if [[ $debug != 1 ]] ; then
while true ; do user_pass_check_exists 
    return_status=$?
    if [ $return_status == 1 ] ; then return 1 ; fi
    if [ $return_status == 2 ] ; then set_rpc_authentication ; break ; fi
    if [ $return_status == 0 ] ; then break ; fi 
    done
fi
fi
    
log "btcpay" "entering make_btcpay_directories..."
make_btcpay_directories  || return 1
    # installed config modifications done
    # .btcpayserver and .nbxplorer

log "btcpay" "entering btcpay_config..."
btcpay_config || return 1

log "btcpay" "entering nbxplorer_config..."
nbxplorer_config || return 1

log "btcpay" "entering build_btcpay..."
build_btcpay || return 1

log "btcpay" "entering run_btcpay_docker..."
run_btcpay_docker || return 1

sleep 4

install_bitcoin_btcpay_mac

start_btcpay

debug "started btcpay"

installed_config_add "btcpay-end"
success "BTCPay Server" "being installed."
log "btcpay" "Btcpay install success"
return 0
}


function install_bitcoin_btcpay_mac {

set_terminal ; echo -e "
########################################################################################

    Parmanode will now install Bitcoin Core inside the BTC Pay docker container.

    It will sync with the existing data directory on your drive.$red 
    
    It is important not to attempt to run a second instance of Bitcoin on your 
    machine, otherwise the existing data is likely to get corrupted.$orange

########################################################################################
"
enter_continue
announce "Please note you may be promped for a password to the 'parman' Docker user." \
"The password is$green parmanode$orange"

please_wait
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_progrms/parmanode && git pull"
docker exec -itu parman bash -c "mkdir -p /home/parman/parmanode/bitcoin"
debug "after install bitcoin"

}