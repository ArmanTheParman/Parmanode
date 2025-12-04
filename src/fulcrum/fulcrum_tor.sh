function fulcrum_tor {

if ! which tor >$dn 2>&1 ; then install_tor ; fi

please_wait

if [[ $OS == Linux ]] ; then
sudo usermod -a -G debian-tor $USER >$dn 2>&1
fi

if ! grep -q "tcp" $fc ; then
echo "tcp = 0.0.0.0:50001" | sudo tee -a $fc >$dn 2>&1
fi

enable_tor_general

if ! sudo grep "HiddenServiceDir $varlibtor/fulcrum-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/fulcrum-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 7002 127.0.0.1:50001" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 7002 127.0.0.1:50001" | sudo tee -a $torrc >$dn 2>&1
fi

restart_tor

get_onion_address_variable "fulcrum" 
parmanode_conf_add "fulcrum_tor=true"
set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to$cyan torrc$orange file, and Tor has been restarted.
########################################################################################
"
enter_continue ; jump $enter_cont

}