function vaultwarden_tor {
enable_tor_general || return 1

if ! sudo grep "HiddenServiceDir $varlibtor/vaultwarden-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/vaultwarden-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7009 127.0.0.1:19080" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7009 127.0.0.1:19080" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor

[[ $insall == "vaultwarden" ]] || get_onion_address_variable "vaultwarden" 

}