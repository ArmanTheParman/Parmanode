function bitcoin_tor {

if [[ $OS == "Mac" ]] ; then 
    varlibtor="/usr/local/var/lib/tor"
    torrc="/usr/local/etc/tor/torrc"
    install_tor
fi

if [[ $OS == "Linux" ]] ; then
    varlibtor="/var/lib/tor"
    torrc="/etc/tor/torrc"
    if ! which tor >/dev/null 2>&1 ; then install_tor ; fi
    sudo usermod -a -G debian-tor $USER >/dev/null 2>&1
fi

#start fresh
delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

enable_tor_general

if ! grep "listen=1" $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1 ; then
    echo "listen=1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

if sudo grep "HiddenServiceDir $varlibtor/bitcoin-service/" \
    $torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir $varlibtor/bitcoin-service/" | sudo tee -a $torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 8332 127.0.0.1:8332" \
    $torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 8332 127.0.0.1:8332" | sudo tee -a $torrc >/dev/null 2>&1
    fi


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
    debug "onion is $ONION_ADDR"
    echo "externalip=$ONION_ADDR" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    delete_line "$HOME/.bitcoin/bitcoin.conf" "bind="
    echo "bind=127.0.0.1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

if [[ $2 == "onlyout" ]] ; then
    delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"
    echo "onlynet=onion" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    fi

    sudo systemctl restart tor
    sudo systemctl restart bitcoind.service #enables tor address

fi #end linux

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file & bitcoin.conf file, and Tor has been 
    restarted.
########################################################################################
"
enter_continue

}