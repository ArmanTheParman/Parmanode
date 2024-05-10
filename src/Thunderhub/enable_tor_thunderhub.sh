function enable_tor_thunderhub {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
source $pc

enable_tor_general || return 1

if sudo grep "HiddenServiceDir /var/lib/tor/thunderhub-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir /var/lib/tor/thunderhub-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 2050 127.0.0.1:$thub_port" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 2050 127.0.0.1:$thub_port" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
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
file="/etc/tor/torrc"
delete_line "$file" "thunderhub"
delete_line "$file" "127.0.0.1:2050"
sudo systemctl restart tor
}
