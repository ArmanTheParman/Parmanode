function enable_mempool_tor {

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

if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
fi

if sudo grep "ControlPort 9051" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "ControlPort 9051" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthentication 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "CookieAuthFileGroupReadable 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "DataDirectoryGroupReadable 1" /etc/tor/torrc | grep -v '^#' >/dev/null 2>&1 ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

# if there's this search string, that doesn't start with #, then...
if sudo grep "HiddenServiceDir /var/lib/tor/mempool-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/mempool-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 8280 127.0.0.1:8180" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 8280 127.0.0.1:8180" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor
restart_mempool >/dev/null
get_onion_address_variable "mempool" 
set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}

function disable_mempool_tor {
delete_line "/etc/tor/torrc" "mempool-service"
delete_line "/etc/tor/torrc" "127.0.0.1:8180"
sudo systemctl restart tor
restart_mempool >/dev/null
set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file, and Tor has been restarted.
########################################################################################
"
enter_continue
}