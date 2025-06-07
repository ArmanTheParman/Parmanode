function electrs_tor {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/electrs-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/electrs-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7004 127.0.0.1:50005" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7004 127.0.0.1:50005" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor
}