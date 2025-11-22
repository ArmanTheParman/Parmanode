function toggle_bitcoin_rpc_tor {


#tor for RPC is off
if ! sudo grep "HiddenServiceDir $varlibtor/bitcoinRPC-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 

    yesorno "Do you want to turn on a TOR onion server address to allow TOR access
    to bitcoin-cli RPC calls? 
    $cyan
    NOTE: this is not the same thing as the p2p network.
          If your p2p connection is clearnet/TOR/I2P, it won't be affected,
          nor change your status. RPC is for direct communication to your Bitcoin
          client's API, you know to do stuff like 'bitcoin-cli getblockchainifo'
          etc. " || return 1

    if ! which tor >$dn 2>&1 ; then 
        clear 
        install_tor
    fi

    if ! which tor >$dn 2>&1 ; then 
        enter_continue "You need to install Tor first. Aborting."
        return 1
    fi

    if [[ ! -e $varlibtor ]] ; then mkdir -p $varlibtor >$dn 2>&1 ; fi
    if [[ ! -e $torrc ]] ; then sudo touch $torrc >$dn 2>&1 ; fi

    enable_tor_general


    if ! sudo grep "HiddenServiceDir $varlibtor/bitcoinRPC-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
        echo "HiddenServiceDir $varlibtor/bitcoinRPC-service/" | sudo tee -a $torrc >$dn 2>&1
    fi

    if ! sudo grep "HiddenServicePort 8332 127.0.0.1:8332" $torrc | grep -v "^#" >$dn 2>&1 ; then 
        echo "HiddenServicePort 8332 127.0.0.1:8332" | sudo tee -a $torrc >$dn 2>&1
    fi

    if [[ $1 != "silent" ]] && sudo grep "HiddenServiceDir $varlibtor/bitcoinRPC-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
        yesorno "Restart Tor to take effect?" && restart_tor
        success "TOR RPC service enabled. It may take a moment and some refreshing for your
        \r    onion address to appear in the Bitcoin menu."
    else
        debug pause before error announcement
        sww "Expected entries in torrc file not detected"
        return 1
    fi

#tor for RPC is on
else
yesorno "Do you want to turn off the TOR onion server address for bitcoin-cli RPC calls?" || return 1
    sudo gsed -i '/8332 127.0.0.1:8332/d' $torrc || { sww && return 1 ; }
    sudo gsed -i '/bitcoinRPC-service/d' $torrc || { sww && return 1 ; }
    yesorno "Restart Tor to take effect?" && restart_tor
    success "Tor RPC disabled"
fi

}