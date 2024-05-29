function start_litd {
    
    if grep -q "litd-" < $ic ; then
    check_rpc_bitcoin
    please_wait
    sudo systemctl start litd.service 
    return 0
    fi 

    if grep -q "litddocker-" < $ic ; then
    litd_docker_start
    fi
}

function stop_litd {
    please_wait
    if grep -q "litd-" < $ic ; then
    sudo systemctl stop litd.service 
    return 0
    fi
    if grep -q "litddocker-" $ic ; then
    litd_docker_stop
    fi
}

function restart_litd {
    if grep -q "litd-" < $ic ; then
    check_rpc_bitcoin
    sudo systemctl restart litd.service 
    return 0
    fi
    if grep -q "litddocker-" < $ic ; then
    litd_docker_stop
    litd_docker_start
    fi
}

function start_litd_loop {

if grep -q "litd-" < $ic ; then
local counter=0
while [[ $counter -lt 6 ]] ; do
if sudo systemctl status >/dev/null ; then return 0 
fi
clear ; echo "Starting litd. Please wait..."
sudo systemctl start litd.service >/dev/null
sleep 3
counter=$((counter + 1))
done
return 0
fi

if grep -q "litddocker-" < $ic ; then

local counter=0
while [[ $counter -lt 6 ]] ; do
if docker exec litd pgrep litd >/dev/null ; then return 0
fi
clear ; echo "Starting litd. Please wait..."
litd_docker_start
sleep 3
counter=$((counter + 1))
done
return 0
fi

}