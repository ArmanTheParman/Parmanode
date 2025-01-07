function nostr_tor_add {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/nostr-service/" $torrc grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/nostr-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7081 127.0.0.1:7080" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7081 127.0.0.1:7080" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor

}

function nostr_tor_remove {

please_wait

sudo gsed -i "/nostr-service/d" $torrc
sudo gsed -i  "/127.0.0.1:7080/d" $torrc

restart_tor

set_terminal
}