function install_btcpay_mac_child {
#called from install_bitcoin.
#docker should be running and checked

export btcpayinstallsbitcoin="true"
set_terminal
sned_sats

choose_btcpay_version || return 1

make_btcpay_directories  || return 1
    # installed config modifications done
    # .btcpayserver and .nbxplorer

btcpay_config || return 1

nbxplorer_config || return 1

build_btcpay || return 1

run_btcpay_docker || return 1

install_bitcoin_btcpay_mac || announce "Error in installing Bitcoin inside Docker container. Continuing with warning."

startup_postgres "install" || return 1 

sleep 4
run_nbxplorer || return 1

sleep 4
run_btcpay || return 1 

docker exec -itu root btcpay apt-get install tor -y

start_btcpay # makes sure all programs started
debug "started btcpay"

installed_config_add "btcpay-end"
installed_config_add "bitcoin-end"
success "BTCPay Server" "being installed."
return 0
}


function install_bitcoin_btcpay_mac {

set_terminal ; echo -e "
########################################################################################

    Parmanode will now add Bitcoin Core inside the BTC Pay docker container.

    It will sync with the existing data directory on your drive.$red 
    
    It is important not to attempt to run a second instance of Bitcoin on your 
    machine, otherwise the existing data is likely to get corrupted.$orange

########################################################################################
"
enter_continue
announce "Please note you may be prompted for a password to the 'parman' Docker user." \
"The password is$green parmanode$orange"

please_wait
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && git pull"
docker exec -itu parman btcpay bash -c "mkdir -p /home/parman/parmanode/bitcoin"
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && btcpayinstallsbitcoin="true" ./run_parmanode.sh" || return 1

}