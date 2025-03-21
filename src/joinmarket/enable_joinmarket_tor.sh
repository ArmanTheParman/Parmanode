function enable_joinmarket_tor {
unset restart
enable_tor_general || return 1
clear
if ! sudo grep "HiddenServiceDir $varlibtor/joinmarket-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/joinmarket-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    restart="true"
fi

if ! sudo grep "HiddenServicePort 5222 127.0.0.1:62601" $torrc | grep -v "^#" >$dn 2>&1 ; then 
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

nogsedtest
sudo gsed -i "/joinmarket-service/d" $file 
sudo gsed -i "/5222 127/d" $file 
restart_tor
}