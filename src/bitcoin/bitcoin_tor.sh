function bitcoin_tor {
nogsedtest
install_tor

if [[ ! -e $varlibtor ]] ; then mkdir -p $varlibtor >$dn 2>&1 ; fi
if [[ ! -e $torrc ]] ; then sudo touch $torrc >$dn 2>&1 ; fi

#start fresh
sudo gsed -i "/onion/d" $bc
sudo gsed -iE "/^bind=/d" $bc
sudo gsed -i "/onlynet/d" $bc
sudo gsed -i "/listenonion=1/d" $bc

enable_tor_general

if ! grep "listen=1" $bc >$dn 2>&1 ; then
    echo "listen=1" | sudo tee -a $bc >$dn 2>&1
fi

if ! sudo grep "HiddenServiceDir $varlibtor/bitcoin-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/bitcoin-service/" | sudo tee -a $torrc >$dn 2>&1
fi

if ! sudo grep "HiddenServicePort 8333 127.0.0.1:8333" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a $torrc >$dn 2>&1
fi

########################################################################################
#Need the Onion address
#Bitcoind stopping - start it up inside this function later

if [[ -z $install_bitcoin_variable ]] ; then
    restart_tor
    stop_bitcoin
fi
    add_rpcbind #modifications might inadvertently delete rpcbind
if [[ -z $install_bitcoin_variable ]] ; then
    start_bitcoin
fi

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
    echo "onion=127.0.0.1:9050" | sudo tee -a $bc >$dn 2>&1
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/externalip=/d" $bc
    echo "externalip=$ONION_ADDR" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/discover=/d" $bc
    echo "discover=1" | sudo tee -a $bc >$dn 2>&1
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=torandclearnet"
    fi

if [[ $1 == "toronly" ]] ; then
    sudo gsed -i "/onion=/d" $bc
    echo "onion=127.0.0.1:9050" | sudo tee -a $bc >$dn 2>&1
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/externalip=/d" $bc
    debug "onion is $ONION_ADDR"
    echo "externalip=$ONION_ADDR" | sudo tee -a $bc >$dn 2>&1
    sudo gsed -i "/^bind=/d" $bc
    echo "bind=127.0.0.1" | sudo tee -a $bc >$dn 2>&1
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=toronly"
    add_rpcbind 
    fi

if [[ $2 == "onlyout" ]] ; then
    sudo gsed -i "/onlynet/d" $bc
    sudo gsed -i "/listenonion=1/d" $bc
    echo "listenonion=1" | sudo tee -a $bc >$dn 2>&1
    echo "onlynet=onion" | sudo tee -a $bc >$dn 2>&1
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=onlyout"
    add_rpcbind 
    fi

restart_tor
if [[ -z $install_bitcoin_variable ]] ; then
stop_bitcoin
start_bitcoin
fi

set_terminal
}

