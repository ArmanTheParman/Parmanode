function enable_joinmarket_tor {
if [[ $OS == "Mac" ]] ; then announce "Tor feature not availalbe for Mac yet." ; return 1 ; fi
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/joinmarket-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/joinmarket-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 5222 127.0.0.1:5222" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 5222 127.0.0.1:5222" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

restart_tor
}

function disable_tor_joinmarket {
if [[ $OS == Mac ]] ; then return 1 ; fi
clear
file="$macprefix/etc/tor/torrc"

sudo gsed -i "/joinmarket-service/d" $file 
sudo gsed -i "/5222 127/d" $file 
restart_tor
}