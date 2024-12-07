function enable_tor_public_pool {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

enable_tor_general || return 1

if sudo grep "HiddenServiceDir $varlibtor/public_pool-service/" \
    $torrc | grep -v "^#" >$dn 2>&1 ; then true ; debug "true" ; else debug "else"
    echo "HiddenServiceDir $varlibtor/public_pool-service/" | sudo tee -a $torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 5055 127.0.0.1:5052" \
    $torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 5055 127.0.0.1:5052" | sudo tee -a $torrc >$dn 2>&1
    fi

restart_tor

get_onion_address_variable "public_pool"

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue ; jump $enter_cont
}

function disable_tor_public_pool {

sudo gsed -i "/public_pool/d" $torrc
sudo gsed -i "/127.0.0.1:5052/d" $torrc
restart_tor
success "Public Pool Tor" "being disabled"
}