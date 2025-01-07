function website_tor_add {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/website-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/website-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 80 127.0.0.1:80" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 80 127.0.0.1:80" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor

get_onion_address_variable "website" 

parmanode_conf_add "website_tor=true"

success "A Tor Hidden service has been set up for you website."
}

function website_tor_remove {

please_wait

sudo gsed -i "/website-service/d" $torrc
sudo gsed -i "/127.0.0.1:80/d" $torrc


set_terminal
parmanode_conf_remove "website_tor"
}