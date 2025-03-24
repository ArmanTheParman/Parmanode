function start_litd {
    
    if grep -q "litd-" $ic ; then
    check_rpc_bitcoin
    please_wait
    sudo systemctl start litd.service 
    return 0
    fi 

    if grep -q "litdpodman-" $ic ; then
    litd_podman_start
    fi
}

function stop_litd {
    please_wait
    if grep -q "litd-" $ic ; then
    sudo systemctl stop litd.service 
    return 0
    fi
    if grep -q "litdpodman-" $ic ; then
    litd_podman_stop
    fi
}

function restart_litd {
    if grep -q "litd-" $ic ; then
    check_rpc_bitcoin
    sudo systemctl restart litd.service 
    return 0
    fi
    if grep -q "litdpodman-" $ic ; then
    litd_podman_stop
    litd_podman_start
    fi
}

function start_litd_loop {

if grep -q "litd-" $ic ; then
local counter=0
while [[ $counter -lt 6 ]] ; do
if sudo systemctl status >$dn ; then return 0 
fi
clear ; echo "Starting litd. Please wait..."
sudo systemctl start litd.service >$dn
sleep 3
counter=$((counter + 1))
done
return 0
fi

if grep -q "litdpodman-" $ic ; then

local counter=0
while [[ $counter -lt 6 ]] ; do
if podman exec litd pgrep litd >$dn ; then return 0
fi
clear ; echo "Starting litd. Please wait..."
litd_podman_start
sleep 3
counter=$((counter + 1))
done
return 0
fi

}