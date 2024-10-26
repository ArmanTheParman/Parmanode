function enable_mempool_tor {
if [[ $OS == "Mac" ]] ; then  no_mac ; return 0 ; fi
if ! which tor >$dn 2>&1 ; then install_tor ; fi   

# macprefix="/usr/local" and empty fro Linux (from parmanode variables)

please_wait

if       [[ $OS == "Linux" ]] \
    &&   grep -q "debian-tor" /etc/group >$dn 2>&1 ; then

    sudo usermod -a -G debian-tor $USER >$dn 2>&1

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

# if there's this search string, that doesn't start with #, then...
if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/mempool-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/mempool-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

if sudo grep "HiddenServicePort 8280 127.0.0.1:8180" \
    $macprefix/etc/tor/torrc | grep -v "^#" >$dn 2>&1 ; then true ; else
    echo "HiddenServicePort 8280 127.0.0.1:8180" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
    fi

sudo systemctl restart tor
restart_mempool >$dn
get_onion_address_variable "mempool" 
set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}

function disable_mempool_tor {
delete_line "$macprefix/etc/tor/torrc" "mempool-service"
delete_line "$macprefix/etc/tor/torrc" "127.0.0.1:8180"
sudo systemctl restart tor
restart_mempool >$dn
set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}