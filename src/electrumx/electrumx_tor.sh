function electrumx_tor {
enable_tor_general || return 1

if sudo grep "HiddenServiceDir $varlibtor/electrumx-service/" \
    /etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir $varlibtor/electrumx-service/" | sudo tee -a $torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 7006 127.0.0.1:50007" \
    $torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 7006 127.0.0.1:50007" | sudo tee -a $torrc >$dn 2>&1
    fi

restart_tor

get_onion_address_variable "electrumx" 

parmanode_conf_add "electrumx_tor=true"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue ; jump $enter_cont
}