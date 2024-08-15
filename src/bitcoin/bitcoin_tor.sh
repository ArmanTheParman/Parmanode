function bitcoin_tor {

if [[ $OS == "Mac" ]] ; then 
    varlibtor="/usr/local/var/lib/tor"
    torrc="/usr/local/etc/tor/torrc"
    if [[ ! -e $varlibtor ]] ; then mkdir $varlibtor ; fi
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

########################################################################################
#Need the Onion address
#Bitcoind stopping - start it up inside this function later

    restart_tor
    restart_bitcoin
    stop_bitcoin

unset $ONION_ADDR
while [[ -z $ONION_ADDR ]] ; do
if [[ $count -gt 0 ]] ; then echo "will try up to 12 times while it thinks" ; fi
get_onion_address_variable "bitcoin"
sleep 1.5
count=$((1 + count))
if [[ $count -gt 12 ]] ; then announce "Couldn't get onion address. Aborting." ; return 1 ; fi
done
########################################################################################


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

restart_tor
restart_bitcoin

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file & bitcoin.conf file, and Tor has been 
    restarted.
########################################################################################
"
enter_continue

}