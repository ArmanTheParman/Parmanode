function parmadesk_tor {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/vnc-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/vnc-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7010 127.0.0.1:21000" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7010 127.0.0.1:21000" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor

[[ $insall == "parmadesk" ]] || get_onion_address_variable "parmadesk" 

}

function parmadesk_tor_remove {
sudo gsed -i '/HiddenServiceDir.*vnc-service/d' $torrc
sudo gsed -i '/HiddenServicePort.*7010 127.0.0.1/d' $torrc
restart_tor
}