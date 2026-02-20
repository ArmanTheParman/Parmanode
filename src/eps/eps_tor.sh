function eps_tor {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/eps-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/eps-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7012 127.0.0.1:50009" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7012 127.0.0.1:50009" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor
}