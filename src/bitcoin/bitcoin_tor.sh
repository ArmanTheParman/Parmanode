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

if ! $xsudo grep "Additions by Parmanode" $torrc ; then enable_tor_general ; fi


if [[ $parmaview == 1 ]] ; then p4run "add_bitcoin_hidden_service"
else {

    if ! sudo grep "HiddenServiceDir $varlibtor/bitcoin-service/" $torrc | grep -v "^#" >$dn 2>&1 ; then 
        echo "HiddenServiceDir $varlibtor/bitcoin-service/" | sudo tee -a $torrc >$dn 2>&1
    fi

    if ! sudo grep "HiddenServicePort 8333 127.0.0.1:8333" $torrc | grep -v "^#" >$dn 2>&1 ; then 
        echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a $torrc >$dn 2>&1
        restart_tor #necessary as the service is new now
    fi
}
fi
debug

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
    count=0 

        while [[ $btcpayinstallsbitcoin != "true" && -z $ONION_ADDR && $count -lt 4 ]] ; do
        sleep 1.5
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
        count=0 
        while [[ $btcpayinstallsbitcoin != "true" && -z $ONION_ADDR && $count -lt 4 ]] ; do
            restart_tor
            get_onion_address_variable  "bitcoin" 
            sleep 1.5
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
    sudo grep -q "discover=0" $bc || echo "discover=0" | $xsudo tee -a $bc >$dn 2>&1
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

function bitcoin_tor_remove { debugf

stop_bitcoin
#delete...
$xsudo gsed -i  "/bitcoin-service/d"          $macprefix/etc/tor/torrc
$xsudo gsed -i  "/127.0.0.1:8333/d"           $macprefix/etc/tor/torrc
$xsudo gsed -i  "/onion/d"                    $bc 
echo "listenonion=0" | $xsudo tee -a $bc >$dn 2>&1
$xsudo gsed -i  "/bind=127.0.0.1/d"           $bc
$xsudo gsed -i  "/onlynet/d"                  $bc


add_rpcbind #adds 0.0.0.0

rm $HOME/.bitcoin/onion* >$dn 2>&1
start_bitcoin
set_terminal
return 0

}

function check_bitcoin_tor_status { debugf
#Function destined for deletion

while true ; do
source $pc

# if no "onion" text in bitcoin.conf, can't be a tor node

if ! grep -q onion $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=c"
    return 0
fi

# if "onlynet=onion" set, must be tor only out.
if grep -q onlynet=onion $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=tonlyout"
    return 0
fi

# if neither of the above, and bind to local host, must be tor only node (in or out)
if grep -q "bind=127.0.0.1" $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=t"
    if grep -q externalip= $db/bitcoin.conf ; then #if externalip exists, must be onion, else break to unkown
         if ! cat $db/bitcoin.conf | grep externalip= | grep -q onion ; then break ; fi 
    fi
    return 0
fi

# if non of the above and discover=1, must be tor and clearnet.
if grep -q "discover=1" $bc ; then
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=tc"
    if grep -q externalip= $bc ; then #if externalip exists, must be onion, else break to unkown 
         if ! cat $bc | grep externalip= | grep -q onion ; then break ; fi 
    fi
    return 0
fi
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=unknown"
break
done

}