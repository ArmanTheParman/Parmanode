function bitcoin_tor { debugf

#start fresh
$xsudo gsed -i "/discover=/d" $bc >$dn 2>&1
$xsudo gsed -i "/onion/d" $bc
$xsudo gsed -i -E "/^bind=/d" $bc
$xsudo gsed -i "/onlynet/d" $bc
$xsudo gsed -i "/listenonion=1/d" $bc
$xsudo gsed -i "/listen=0/d" $bc
$xsudo gsed -i "/externalip=/d" $bc >$dn 2>&1
$xsudo gsed -i -E "/^\s*$/d" $bc >$dn 2>&1

if [[ $1 == "clearnet" ]] ; then
    $xsudo gsed -i "/onion=/d" $bc
    local exit_early="true" #no need to get onion address
fi

install_tor

if [[ ! -e $varlibtor ]] ; then mkdir -p $varlibtor >$dn 2>&1 ; fi
if [[ ! -e $torrc ]] ; then $xsudo touch $torrc >$dn 2>&1 ; fi

enable_tor_general


if ! $xsudo grep "HiddenServiceDir $varlibtor/bitcoin-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServiceDir $varlibtor/bitcoin-service/" | $xsudo tee -a $torrc >$dn 2>&1
fi

if ! $xsudo grep "HiddenServicePort 8333 127.0.0.1:8333" $torrc | grep -v "^#" >$dn 2>&1 ; then 
    echo "HiddenServicePort 8333 127.0.0.1:8333" | $xsudo tee -a $torrc >$dn 2>&1
    restart_tor #necessary as the service is new now
fi

# discover=0 (dont advertise clearnet IP) ; if not set, default is 1

if [[ $1 == "torandclearnet" ]] ; then
    $xsudo gsed -i "/onion=/d" $bc
    if grep -q btcpaycombo-end $ic ; then
        echo "onion=host.docker.internal:9050" | $xsudo tee -a $bc >$dn 2>&1
    else
        echo "onion=127.0.0.1:9050" | $xsudo tee -a $bc >$dn 2>&1
    fi
    echo "listenonion=1" | $xsudo tee -a $bc >$dn 2>&1
    get_onion_address_variable "bitcoin"
        count=0 ; while [[ $btcpayinstallsbitcoin != "true" && -z $ONION_ADDR && $count -lt 4 ]] ; do
        sleep 3
        get_onion_address_variable "bitcoin"
        count=$((count + 1))
    done 
    [[ -z $ONION_ADDR ]] && sww "Some issue with getting onion address. Try later or switch to no Tor." && return 1
    echo "externalip=$ONION_ADDR" | $xsudo tee -a $bc >$dn 2>&1
    $xsudo gsed -i "/discover=/d" $bc
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=torandclearnet"
    fi

if [[ $1 == "toronly" ]] ; then
    $xsudo gsed -i "/onion=/d" $bc
    grep -q "discover=0" $bc || echo "discover=0" | $xsudo tee -a $bc >$dn 2>&1
    echo "listenonion=1" | $xsudo tee -a $bc >$dn 2>&1
    echo "onlynet=onion" | $xsudo tee -a $bc >$dn 2>&1 #new, disallows outward clearnet connections

    if grep -q btcpaycombo-end $ic ; then
        echo "onion=host.docker.internal:9050" | $xsudo tee -a $bc >$dn 2>&1
    else
        echo "onion=127.0.0.1:9050" | $xsudo tee -a $bc >$dn 2>&1
    fi
        count=0 ; while [[ $btcpayinstallsbitcoin != "true" && -z $ONION_ADDR && $count -lt 4 ]] ; do
        restart_tor
        sleep 3
        get_onion_address_variable "bitcoin"
        count=$((count + 1))
        done 

    get_onion_address_variable "bitcoin"

    [[ -z $ONION_ADDR ]] && sww "Some issue with getting onion address. Try later or switch to no Tor." && return 1
    echo "externalip=$ONION_ADDR" | $xsudo tee -a $bc >$dn 2>&1
    parmanode_conf_remove "bitcoin_tor_status"
    parmanode_conf_add "bitcoin_tor_status=toronly"
    add_rpcbind 
    fi

if [[ $2 == "onlyout" ]] ; then
    $xsudo gsed -i "/onlynet/d" $bc
    $xsudo gsed -i "/listenonion=1/d" $bc
    echo "listen=0" | $xsudo tee -a $bc >$dn 2>&1
    $xsudo gsed -i -E '/^bind=/d' $bc
    $xsudo gsed -i "/externalip/d" $bc >$dn 2>&1
    $xsudo grep -q "discover=0" $bc || echo "discover=0" | $xsudo tee -a $bc >$dn 2>&1
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

if [[ $exit_early == "true" ]] ; then return 0 ; fi


unset $ONION_ADDR
please_wait
get_onion_address_variable "bitcoin"
while [[ -z $ONION_ADDR ]] ; do
[[ -z $install_bitcoin_variable ]] && get_onion_address_variable "bitcoin"
sleep 1.5
count=$((1 + count))
if [[ $count -gt 4 ]] ; then return 1 ; fi
done

########################################################################################
#Need the Onion address
#Bitcoind stopping - start it up inside this function later

if [[ $install != "bitcoin" ]] ; then
    restart_tor
    stop_bitcoin
fi
    add_rpcbind #modifications might inadvertently delete rpcbind
    
if [[ $install != "bitcoin" ]] ; then
    start_bitcoin
fi

########################################################################################


}

