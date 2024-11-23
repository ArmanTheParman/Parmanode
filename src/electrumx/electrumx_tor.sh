function electrumx_tor {
debug "line 2, in electrumx tor"
enable_tor_general || return 1
debug "line 4, in electrumx tor, after enable_tor_general"

if sudo grep "HiddenServiceDir /var/lib/tor/electrumx-service/" \
    /etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir /var/lib/tor/electrumx-service/" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 7006 127.0.0.1:50007" \
    /etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 7006 127.0.0.1:50007" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    fi

sudo systemctl restart tor

get_onion_address_variable "electrumx" 

parmanode_conf_add "electrumx_tor=true"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue ; jump $enter_cont
}