function bitcoin_tor { debugf

#start fresh
sudo /usr/local/parmanode/p4run "bitcoin_tor" "startfresh"

if [[ $1 == "clearnet" ]] ; then
    local exit_early="true" # No need to get onion address, but still need 
                            # to check for restart tor/bitcoin to clear settings if not called 
                            # from bitcoin_install()
else
install_tor #should be installed already, since have added Tor as a dependency to Parmanode.
enable_tor_general

    #probably redundant
    if [[ $OS == "Mac" ]] ; then
        if [[ ! -e $varlibtor ]] ; then mkdir -p $varlibtor >$dn 2>&1 ; fi
    fi

sudo /usr/local/parmanode/p4run "add_bitcoin_hidden_service"
        restart_tor #necessary as the service is new now
fi
debug

# NOTES # discover=0 (dont advertise clearnet IP) ; if not set, default is 1

if [[ $1 == "torandclearnet" ]] ; then
    if grep -q btcpaycombo-end $ic ; then
        sudo /usr/local/parmanode/p4run "bitcoin_tor" "host_docker_internal"
    else
        sudo /usr/local/parmanode/p4run "bitcoin_tor" "localhost_onion"
    fi
    sudo /usr/local/parmanode/p4run "bitcoin_tor" "listen_onion"
    export ONION_ADDR=$(sudo /usr/local/parmanode/p4run "get_onion_address_variable" "bitcoin")
    count=0 

        while [[ $btcpayinstallsbitcoin != "true" && -z $ONION_ADDR && $count -lt 4 ]] ; do
        sleep 1.5
        export ONION_ADDR=$(sudo /usr/local/parmanode/p4run "get_onion_address_variable" "bitcoin")
        count=$((count + 1))
        done 

    [[ -z $ONION_ADDR ]] && sww "Some issue with getting onion address. Try later or switch to no Tor." && return 1
    sudo /usr/local/parmanode/p4run "bitcoin_tor" "externalip" "$ONION_ADDR"
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=torandclearnet"
    fi

if [[ $1 == "toronly" ]] ; then
    sudo /usr/local/parmanode/p4run "bitcoin_tor" "toronly"
debug
    if grep -q btcpaycombo-end $ic ; then
        sudo /usr/local/parmanode/p4run "bitcoin_tor" "host_docker_internal"
    else
        debug
        sudo /usr/local/parmanode/p4run "bitcoin_tor" "localhost_onion"
    fi
debug
    count=0 
    while [[ $btcpayinstallsbitcoin != "true" && -z $ONION_ADDR && $count -lt 4 ]] ; do
        restart_tor
        export ONION_ADDR=$(sudo /usr/local/parmanode/p4run "get_onion_address_variable" "bitcoin")
        sleep 1.5
        count=$((count + 1))
        debug
    done 
debug

    [[ -z $ONION_ADDR ]] && sww "Some issue with getting onion address. Try later or switch to no Tor." && return 1
    sudo /usr/local/parmanode/p4run "bitcoin_tor" "externalip" "$ONION_ADDR"
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=toronly"
    sudo /usr/local/parmanode/p4run "rpcbind"
    debug
    fi

if [[ $2 == "onlyout" ]] ; then
    sudo /usr/local/parmanode/p4run "bitcoin_tor" "onlyout"
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=onlyout"
    sudo /usr/local/parmanode/p4run "rpcbind"
    fi

restart_tor
if [[ -z $install_bitcoin_variable ]] ; then #if this is not called by bitcoin install, then restart bitcoin
stop_bitcoin
start_bitcoin
fi

set_terminal

if [[ $exit_early == "true" ]] ; then return 0 ; fi

please_wait
[[ -z $ONION_ADDR ]] && export ONION_ADDR=$(sudo /usr/local/parmanode/p4run "get_onion_address_variable" "bitcoin")
    while [[ -z $ONION_ADDR ]] ; do
        [[ -z $install_bitcoin_variable ]] && export ONION_ADDR=$(sudo /usr/local/parmanode/p4run "get_onion_address_variable" "bitcoin")
        sleep 1.5
        count=$((1 + count))
        if [[ $count -gt 4 ]] ; then return 1 ; fi
    done

sudo /usr/local/parmanode/p4run "rpcbind" #modifications might inadvertently delete rpcbind

############### ###############
#Need the Onion address
#Bitcoind stopping - start it up inside this function later

if [[ $install != "bitcoin" ]] ; then
    restart_tor
    stop_bitcoin
    start_bitcoin
fi

}

########################################################################################

function bitcoin_tor_remove { debugf

stop_bitcoin
sudo /usr/local/parmanode/p4run "bitcoin_tor" "remove_bitcoin_hidden_service"
sudo /usr/local/parmanode/p4run "rpcbind" #modifications might inadvertently delete rpcbind
rm $HOME/.bitcoin/onion* >$dn 2>&1
start_bitcoin
set_terminal
return 0

}

function check_bitcoin_tor_status { debugf
#Function destined for deletion

while true ; do
source $pc

# if no "onion" text in bitcoin.conf, can't be a tor node

if ! grep -q onion $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=c"
    return 0
fi

# if "onlynet=onion" set, must be tor only out.
if grep -q onlynet=onion $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=tonlyout"
    return 0
fi

# if neither of the above, and bind to local host, must be tor only node (in or out)
if grep -q "bind=127.0.0.1" $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=t"
    if grep -q externalip= $bc ; then #if externalip exists, must be onion, else break to unkown
         if ! cat $bc | grep externalip= | grep -q onion ; then break ; fi 
    fi
    return 0
fi

# if non of the above and discover=1, must be tor and clearnet.
if grep -q "discover=1" $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=tc"
    if grep -q externalip= $bc ; then #if externalip exists, must be onion, else break to unknown 
         if ! cat $bc | grep externalip= | grep -q onion ; then break ; fi 
    fi
    return 0
fi
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=unknown"
break
done

}