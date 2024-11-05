function enable_tor_thunderhub {
if [[ $OS == Mac ]] ; then return 0 ; fi
source $pc

enable_tor_general || return 1

if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/thunderhub-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir $macprefix/var/lib/tor/thunderhub-service/" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 2050 127.0.0.1:$thub_port" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 2050 127.0.0.1:$thub_port" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

get_onion_address_variable "thunderhub"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}

function disable_tor_thunderhub {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
file="$macprefix/etc/tor/torrc"
sudo gsed -i "/thunderhub/d" $file 
sudo gsed -i "/127.0.0.1:2050/d" $file 
sudo systemctl restart tor
}
