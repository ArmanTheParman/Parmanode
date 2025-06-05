function check_bitcoin_tor_status {
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