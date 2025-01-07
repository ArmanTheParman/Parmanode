function enable_tor_thunderhub {
source $pc

enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/thunderhub-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/thunderhub-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 2050 127.0.0.1:$thub_port" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 2050 127.0.0.1:$thub_port" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor

get_onion_address_variable "thunderhub"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue ; jump $enter_cont
}

function disable_tor_thunderhub {
sudo gsed -i "/thunderhub/d" $torrc
sudo gsed -i "/127.0.0.1:2050/d" $torrc
restart_tor
}
