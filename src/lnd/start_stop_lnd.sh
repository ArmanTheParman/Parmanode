function start_lnd {
    if grep -q "litd" $ic ; then start_litd ; return 0 ; fi 
    if grep -q "lnd-" $ic ; then
    check_rpc_bitcoin
    please_wait
    pn_tmux "sudo systemctl start lnd.service" 
    return 0
    fi 

    if grep -q "lnddocker-" $ic ; then
    lnd_docker_start
    fi
}

function stop_lnd {
    please_wait
    if grep -q "litd" $ic ; then stop_litd ; return 0 ; fi 

    if grep -q "lnd-" $ic ; then
    pn_tmux "sudo systemctl stop lnd.service"
    return 0
    fi

    if grep -q "lnddocker-" $ic ; then
    lnd_docker_stop
    fi
}

function restart_lnd {
    if grep -q "litd" $ic ; then restart_litd ; return 0 ; fi 

    if grep -q "lnd-" $ic ; then
    check_rpc_bitcoin
    pn_tmux "sudo systemctl restart lnd.service"
    return 0
    fi

    if grep -q "lnddocker-" $ic ; then
    lnd_docker_stop
    lnd_docker_start
    fi
}

function start_LND_loop {

if grep -q "lnd-" $ic ; then
local counter=0
while [[ $counter -lt 6 ]] ; do
if sudo systemctl status >$dn ; then return 0 
fi
clear ; echo "Starting LND. Please wait..."
pn_tmux "sudo systemctl start lnd.service"
sleep 3
counter=$((counter + 1))
done
return 0
fi

if grep -q "lnddocker-" $ic ; then

local counter=0
while [[ $counter -lt 6 ]] ; do
if docker exec lnd pgrep lnd >$dn ; then return 0
fi
clear ; echo "Starting LND. Please wait..."
lnd_docker_start
sleep 3
counter=$((counter + 1))
done
return 0
fi

}