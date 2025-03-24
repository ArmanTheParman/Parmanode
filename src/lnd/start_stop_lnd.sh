function start_lnd {
    if grep -q "litd" $ic ; then start_litd ; return 0 ; fi 
    if grep -q "lnd-" $ic ; then
    check_rpc_bitcoin
    please_wait
    sudo systemctl start lnd.service
    return 0
    fi 

    if grep -q "lndpodman-" $ic ; then
    lnd_podman_start
    fi
}

function stop_lnd {
    please_wait
    if grep -q "litd" $ic ; then stop_litd ; return 0 ; fi 

    if grep -q "lnd-" $ic ; then
    sudo systemctl stop lnd.service
    sleep 1.5
    return 0
    fi

    if grep -q "lndpodman-" $ic ; then
    lnd_podman_stop
    fi
}

function restart_lnd {
    if grep -q "litd" $ic ; then restart_litd ; return 0 ; fi 

    if grep -q "lnd-" $ic ; then
    check_rpc_bitcoin
    systemctl restart lnd.service
    return 0
    fi

    if grep -q "lndpodman-" $ic ; then
    lnd_podman_stop
    lnd_podman_start
    fi
}

function start_LND_loop {

if grep -q "lnd-" $ic ; then
local counter=0
while [[ $counter -lt 6 ]] ; do
if sudo systemctl status >$dn ; then return 0 
fi
clear ; echo "Starting LND. Please wait..."
sudo systemctl start lnd.service
sleep 3
counter=$((counter + 1))
done
return 0
fi

if grep -q "lndpodman-" $ic ; then

local counter=0
while [[ $counter -lt 6 ]] ; do
if podman exec lnd pgrep lnd >$dn ; then return 0
fi
clear ; echo "Starting LND. Please wait..."
lnd_podman_start
sleep 3
counter=$((counter + 1))
done
return 0
fi

}