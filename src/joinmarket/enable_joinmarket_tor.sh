function enable_joinmarket_tor {
unset restart
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/joinmarket-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/joinmarket-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    restart="true"
fi

if sudo grep "HiddenServicePort 5222 127.0.0.1:62601" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 5222 127.0.0.1:62601" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    restart="true"
fi

if [[ $restart == "true" ]] ; then
    restart_tor
fi
}

function disable_tor_joinmarket {
clear
file="$macprefix/etc/tor/torrc"

sudo gsed -i "/joinmarket-service/d" $file 
sudo gsed -i "/5222 127/d" $file 
restart_tor
}