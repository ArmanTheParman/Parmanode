function store_LND_container_IP {

if grep -q "LNDIP" $pc >$dn 2>&1 ; then
debug "LNDIP exists, exiting"
source $pc
return 0
fi

if grep -q "lnd-" $ic || grep -q "litd" $ic ; then 
LNDIP=$IP
debug "LNDIP=\$IP ... $LNDIP ... $IP ."

    if ! echo $LNDIP | grep -qE '^[0-9]' ; then #double check LNDIP starts with a number rather than error message
       unset LNDIP
       return 1
    else 
       parmanode_conf_add "LNDIP=$LNDIP"
       export LNDIP
       return 0
    fi
return 0
fi

debug "3"

if ! podman ps >$dn 2>&1 ; then return 1 ; fi

if podman ps | grep -q lnd ; then

    LNDIP=$(podman inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' lnd)

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
