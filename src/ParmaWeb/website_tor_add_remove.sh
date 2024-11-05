function website_tor_add {
enable_tor_general || return 1

if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/website-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true 
    else 
    echo "HiddenServiceDir $macprefix/var/lib/tor/website-service/" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 80 127.0.0.1:80" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true 
    else
    echo "HiddenServicePort 80 127.0.0.1:80" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

get_onion_address_variable "website" 

parmanode_conf_add "website_tor=true"

success "A Tor Hidden service has been set up for you website."
}

function website_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

sudo gsed -i "/website-service/d" $macprefix/etc/tor/torrc 
sudo gsed -i "/127.0.0.1:80/d" $macprefix/etc/tor/torrc 

sudo systemctl restart tor

set_terminal
parmanode_conf_remove "website_tor"
}