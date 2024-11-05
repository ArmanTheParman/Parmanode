function bitcoin_tor {

install_tor

varlibtor="$macprefix/var/lib/tor"
torrc="$macprefix/etc/tor/torrc" 

if [[ ! -e $varlibtor ]] ; then mkdir $varlibtor >$dn 2>&1 ; fi
if [[ ! -e $torrc ]] ; then sudo touch $torrc >$dn 2>&1 ; fi

#start fresh
sudo gsed -i "/onion/d" $bc
sudo gsed -i "/bind=127.0.0.1/d" $bc
sudo gsed -i "/onlynet/d" $bc
sudo gsed -i "/listenonion=1/d" $bc

enable_tor_general

if ! grep "listen=1" $bc >/dev/null 2>&1 ; then
    echo "listen=1" | sudo tee -a $bc >/dev/null 2>&1
    fi

if sudo grep "HiddenServiceDir $varlibtor/bitcoin-service/" \
    $torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir $varlibtor/bitcoin-service/" | sudo tee -a $torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 8333 127.0.0.1:8333" \
    $torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a $torrc >/dev/null 2>&1
    fi

########################################################################################
#Need the Onion address
#Bitcoind stopping - start it up inside this function later

    restart_tor

    stop_bitcoin
    add_rpcbind #modifications might inadvertently delete rpcbind
    start_bitcoin

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
    sudo gsed -i "/onion=/d" $bc
    echo "onion=127.0.0.1:9050" | sudo tee -a $bc >/dev/null 2>&1
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/externalip=/d" $bc
    echo "externalip=$ONION_ADDR" | sudo tee -a $bc >/dev/null 2>&1
    sudo gsed -i "/discover=/d" $bc
    echo "discover=1" | sudo tee -a $bc >/dev/null 2>&1
    fi

if [[ $1 == "toronly" ]] ; then
    sudo gsed -i "/onion=/d" $bc
    echo "onion=127.0.0.1:9050" | sudo tee -a $bc >/dev/null 2>&1
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/externalip=/d" $bc
    debug "onion is $ONION_ADDR"
    echo "externalip=$ONION_ADDR" | sudo tee -a $bc >/dev/null 2>&1
    sudo gsed -i "/bind=/d" $bc
    echo "bind=127.0.0.1" | sudo tee -a $bc >/dev/null 2>&1
    fi

if [[ $2 == "onlyout" ]] ; then
    sudo gsed -i "/onlynet/d" $bc
    sudo gsed -i "/listenonion=1/d" $bc
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    echo "onlynet=onion" | sudo tee -a $bc >/dev/null 2>&1
    fi

restart_tor
stop_bitcoin
start_bitcoin

set_terminal ; echo -e "
########################################################################################
    FYI, changes have been made to torrc file & bitcoin.conf file, and Tor has been 
    restarted.
########################################################################################
"
enter_continue

}
