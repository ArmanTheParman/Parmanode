function bitcoin_tor {

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

#start fresh
delete_line "/etc/tor/torrc" "# Additions by Parmanode"
delete_line "/etc/tor/torrc" "bitcoin-service"
delete_line "/etc/tor/torrc" "127.0.0.1:8332"
delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

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

if ! grep "listen=1" $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1 ; then
    echo "listen=1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

if sudo grep "HiddenServiceDir /var/lib/tor/bitcoin-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/bitcoin-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 8332 127.0.0.1:8332" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 8332 127.0.0.1:8332" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

#Bitcoind stopping - start it up inside this function later

    sudo systemctl restart tor
    sudo systemctl restart bitcoind.service #enables tor address
    sudo systemctl stop bitcoind.service

get_onion_address_variable "bitcoin"

if [[ $1 == "torandclearnet" ]] ; then
    delete_line "$HOME/.bitcoin/bitcoin.conf" "onion="
    echo "onion=127.0.0.1:9050" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    delete_line "$HOME/.bitcoin/bitcoin.conf" "externalip="
    echo "externalip=$ONION_ADDR" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    delete_line "$HOME/.bitcoin/bitcoin.conf" "discover="
    echo "discover=1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

if [[ $1 == "toronly" ]] ; then
    delete_line "$HOME/.bitcoin/bitcoin.conf" "onion="
    echo "onion=127.0.0.1:9050" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    delete_line "$HOME/.bitcoin/bitcoin.conf" "externalip="
    echo "externalip=$ONION_ADDR" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    delete_line "$HOME/.bitcoin/bitcoin.conf" "bind="
    echo "bind=127.0.0.1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

if [[ $2 == "onlyout" ]] ; then
    delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"
    echo "onlynet=onion" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

    sudo systemctl start bitcoind.service
    sudo systemctl restart tor
clear
echo "
     Changes have been made to torrc file and bitcoin.conf file, and Bitcoin
     has been restarted.
"
enter_continue

}