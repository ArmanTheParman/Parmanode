function enable_tor_public_pool {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

enable_tor_general || return 1

if sudo grep "HiddenServiceDir /var/lib/tor/public_pool-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir /var/lib/tor/public_pool-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 5055 localhost:5050" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 5055 localhost:5050" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

get_onion_address_variable "public_pool" >/dev/null 2>&1

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}

function disable_tor_public_pool {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
file="/etc/tor/torrc"
delete_line "$file" "public_pool"
delete_line "$file" "localhost:5050"
sudo systemctl restart tor
success "Public Pool Tor" "being disabled"
}