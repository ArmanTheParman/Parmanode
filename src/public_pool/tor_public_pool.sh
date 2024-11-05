function enable_tor_public_pool {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

enable_tor_general || return 1

if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/public_pool-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir $macprefix/var/lib/tor/public_pool-service/" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 5055 127.0.0.1:5052" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 5055 127.0.0.1:5052" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

get_onion_address_variable "public_pool"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}

function disable_tor_public_pool {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
file="$macprefix/etc/tor/torrc"
sudo gsed -i "/public_pool/d" $file 
sudo gsed -i "/127.0.0.1:5052/d" $file 
sudo systemctl restart tor
success "Public Pool Tor" "being disabled"
}