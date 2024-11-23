function fulcrum_tor {

if ! which tor >$dn 2>&1 ; then install_tor ; fi

please_wait

if [[ $OS == Linux ]] ; then
sudo usermod -a -G debian-tor $USER >$dn 2>&1
fi

if ! grep -q "tcp" $fc ; then
echo "tcp = 0.0.0.0:50001" | sudo tee -a $fc >$dn 2>&1
fi

if ! sudo cat $macprefix/etc/tor/torrc | grep "# Additions by Parmanode..." >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
fi

if sudo grep "ControlPort 9051" $macprefix/etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "CookieAuthentication 1" $macprefix/etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" $macprefix/etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" $macprefix/etc/tor/torrc | grep -v '^#' >$dn 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/fulcrum-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/fulcrum-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 7002 127.0.0.1:50001" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 7002 127.0.0.1:50001" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
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