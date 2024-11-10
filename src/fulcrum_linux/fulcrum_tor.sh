function fulcrum_tor {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! which tor >/dev/null 2>&1 ; then install_tor ; fi

if [[ ! -f /etc/tor/torrc ]] ; then
set_terminal ; echo "
########################################################################################
    /etc/tor/torrc file does not exist. You may have a non-standard Tor installation.
    Parmanode won't be able to automate this process for you. Sorry! Aborting.
########################################################################################
"
enter_continue ; return 1 ;
fi

please_wait

sudo usermod -a -G debian-tor $USER >/dev/null 2>&1

if ! cat $fc | grep "tcp" >/dev/null 2>&1 ; then
    echo "tcp = 0.0.0.0:50001" | sudo tee -a $fc >/dev/null 2>&1
    fi

if ! sudo cat $macprefix/etc/tor/torrc | grep "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
fi

if sudo grep "ControlPort 9051" $macprefix/etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthentication 1" $macprefix/etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" $macprefix/etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" $macprefix/etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/fulcrum-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/fulcrum-service/" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7002 127.0.0.1:50001" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7002 127.0.0.1:50001" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor
sudo systemctl restart fulcrum.service

get_onion_address_variable "fulcrum" 
parmanode_conf_add "fulcrum_tor=true"
set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue

}