function install_btcpay_mac_child {
#called from install_bitcoin.
#docker should be running and checked
debug "in install_btcpay_mac_child"

export btcpayinstallsbitcoin="true"
set_terminal
sned_sats

btcpay_install_restore_choice || { sww ; menu_main ; }

#removed when testing install bitcoin with btcpay combo...
#choose_btcpay_version || { parmanode_conf_remove "btcpay_version=" ; sww ; menu_main ; }

make_btcpay_directories  || { announce "Something went wrong. Aborting." ; sww ; menu_main ; }
    # installed config modifications done
    # .btcpayserver and .nbxplorer

btcpay_config || { sww ; menu_main ; }

nbxplorer_config || { sww ; menu_main ; }

build_btcpay || { sww ; menu_main ; }

run_btcpay_docker || { sww ; menu_main ; }

install_bitcoin_inside_docker|| sww "Error in installing Bitcoin inside Docker container. Continuing with warning."

initialise_postgres_btcpay || { sww ; menu_main ; }

sleep 4
start_nbxplorer_indocker || { sww ; menu_main; }

sleep 4
start_btcpay_indocker || { sww ; menu_main ; }

docker exec -itu root btcpay bash -c "apt-get install tor -y"

#start_btcpay

installed_config_add "btcpay-end"
installed_config_add "bitcoin-end"
installed_config_add "btccombo-end"
return 0
}


function install_bitcoin_inside_docker {

set_terminal ; echo -e "
########################################################################################

    Parmanode will now add Bitcoin inside the BTC Pay docker container.

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
#when developting on non-master branches, need to checkout to the correct branch...
cd $pn >$dn ; onbranch=$(git status | grep "On branch" | sed 's/On branch/ /g' | grep -Eo '[a-z:A-Z:0-9].+') ; cd - >$dn
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && git checkout $onbranch"
docker exec -itu parman btcpay bash -c "cd /home/parman/parman_programs/parmanode && git pull"
docker exec -itu root btcpay bash -c "ln -s /usr/bin/sed /usr/bin/gsed"
[[ $debug == "1" ]] && docker exec -itu parman btcpay bash -c "touch /tmp/debugon"
docker exec -itu parman btcpay bash -l -c "echo 'parmanode' | sudo -S true ; export dn=/dev/null ; cd /home/parman/parman_programs/parmanode && \
                                            btcpayinstallsbitcoin=\"true\" ./run_parmanode.sh" || return 1
if [[ $onbranch != "master" ]] ; then
    if yesorno "Revert container's Parmanode install back to master branch?" ; then 
        docker exec -itu parman btcpay bash -c "cd /home/parman/parmandd_programs/parmanode && git checkout master"
    fi
fi
return 0
}
