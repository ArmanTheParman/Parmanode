function enable_tor_litterminal {
if [[ $OS == Mac ]] ; then announce "Tor feature not availalbe for Mac yet." ; return 1 ; fi

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/litterminal-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/litterminal-service/" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7007 127.0.0.1:8443" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7007 127.0.0.1:8443" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor
}

function disable_tor_litterminal {
if [[ $OS == Mac ]] ; then return 1 ; fi
clear
file="$macprefix/etc/tor/torrc"

sudo gsed -i "/litterminal-service/d" $file
sudo gsed -i "/7007 127/d" $file
sudo systemctl restart tor

}