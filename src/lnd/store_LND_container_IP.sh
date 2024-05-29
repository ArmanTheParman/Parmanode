function store_LND_container_IP {

if grep -q "LNDIP" < $pc >/dev/null 2>&1 ; then
source $pc
return 0
fi

if grep -q "lnd-" < $pc || grep -q "litd" < $pc ; then 
LNDIP=$IP

    if ! echo $LNDIP | grep -E '^[0-9]' ; then #double check LNDIP starts with a number rather than error message
       unset LNDIP
       return 1
    else 
       parmanode_conf_add "LNDIP=$LNDIP"
       export LNDIP
       return 0
    fi
return 0
fi

if ! docker ps >/dev/null 2>&1 ; then return 1 ; fi

if docker ps | grep -q lnd ; then

    LNDIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' lnd)

    if ! echo $LNDIP | grep -qE '^[0-9]' ; then #double check LNDIP starts with a number rather than error message
       unset LNDIP
       return 1
    else 
       parmanode_conf_add "LNDIP=$LNDIP"
       export LNDIP
       return 0
    fi

fi

}
