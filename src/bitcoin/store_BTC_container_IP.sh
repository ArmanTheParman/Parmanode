function store_BTC_container_IP {

if grep -q "BTCIP" < $pc >/dev/null 2>&1 ; then
source $pc
return 0
fi

if grep -q "btccombo-" < $pc ; then 
BTCIP=$IP

    if ! echo $BTCIP | grep -qE '^[0-9]' ; then #double check BTCIP starts with a number rather than error message
       unset BTCIP
       return 1
    else 
       parmanode_conf_add "BTCIP=$BTCIP"
       export BTCIP
       return 0
    fi
return 0
fi

if ! docker ps >/dev/null 2>&1 ; then return 1 ; fi

if docker ps | grep -q btcpay ; then

    BTCIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' btcpay)

    if ! echo $BTCIP | grep -qE '^[0-9]' ; then #double check BTCIP starts with a number rather than error message
       unset BTCIP
       return 1
    else 
       parmanode_conf_add "BTCIP=$BTCIP"
       export BTCIP
       return 0
    fi

fi

}