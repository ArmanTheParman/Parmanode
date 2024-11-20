function electrs_tor {
debug "line 2, in electrs tor"
enable_tor_general || return 1
debug "line 4, in electrs tor, after enable_tor_general"

if sudo grep "HiddenServiceDir /var/lib/tor/electrs-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir /var/lib/tor/electrs-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

debug "after hidden service echo"

if sudo grep "HiddenServicePort 7004 127.0.0.1:50005" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7004 127.0.0.1:50005" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

debug "line 18, before restart tor"
sudo systemctl restart tor

get_onion_address_variable "electrs" 

parmanode_conf_add "electrs_tor=true"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue ; jump $enter_cont
}