function enable_tor_btcpay {
clear
enable_tor_general || return 1
clear
if ! sudo grep "HiddenServiceDir $varlibtor/btcpay-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/btcpay-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7003 127.0.0.1:23001" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7003 127.0.0.1:23001" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor
}

function disable_tor_btcpay {
clear
nogsedtest
sudo gsed -i "/btcpay-service/d" $torrc
sudo gsed -i "/7003 127/d" $torrc
restart_tor

}