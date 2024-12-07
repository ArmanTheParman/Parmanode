function enable_tor_litterminal {

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $varlibtor/litterminal-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $varlibtor/litterminal-service/" | sudo tee -a $torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 7007 127.0.0.1:8443" \
    $torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 7007 127.0.0.1:8443" | sudo tee -a $torrc >$dn 2>&1
    fi

restart_tor
}

function disable_tor_litterminal {
if [[ $OS == "Mac" ]] ; then return 1 ; fi
clear

sudo gsed -i "/litterminal-service/d" $torrc
sudo gsed -i "/7007 127/d" $torrc
restart_tor

}