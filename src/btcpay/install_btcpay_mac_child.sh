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

install_bitcoin_inside_docker|| announce "Error in installing Bitcoin inside Docker container. Continuing with warning."

initialise_postgres_btcpay || return 1 

sleep 4
start_nbxplorer_indocker || return 1

sleep 4
start_btcpay_indocker || return 1 

docker exec -itu root btcpay bash -c "apt-get install tor -y"

#start_btcpay_all_programs 

installed_config_add "btcpay-end"
installed_config_add "bitcoin-end"
installed_config_add "btccombo-end"
return 0
}


function install_bitcoin_inside_docker {

set_terminal ; echo -e "
########################################################################################

    Parmanode will now add Bitcoin Core inside the BTC Pay docker container.

    It will sync with the existing data directory on your drive.$red 
    
    It is important not to attempt to run a second instance of Bitcoin on your 
    machine, otherwise the existing data is likely to get corrupted.$orange

    Just in case you get a prompt, the user inside the container is 'parman' and the
    password for the user is 'parmanode'.

########################################################################################
"
enter_continue
#announce "Please note you MAY be prompted for a password to the 'parman' Docker user." \
#"The password is$green$blinkon parmanode$blinkoff$orange"

please_wait
docker exec -itu parman btcpay bash -c "if ! git config --global user.name ; then git config --global user.name Parman ; fi"
docker exec -itu parman btcpay bash -c "if ! git config --global user.email ; then git config --global user.email sample@parmanode.com ; fi"
docker exec -itu parman btcpay bash -c "mkdir -p /home/parman/parmanode/bitcoin"
onbranch=$(git status | grep "On branch" | sed 's/On branch/ /g' | grep -Eo '[a-z:A-Z:0-9].+')
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && git checkout $onbranch"
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && git pull"
docker exec -itu parman btcpay bash -c "echo 'parmanode' | sudo -S true ; cd /home/parman/parman_programs/parmanode && btcpayinstallsbitcoin="true" ./run_parmanode.sh" || return 1
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && git checkout master"
}
