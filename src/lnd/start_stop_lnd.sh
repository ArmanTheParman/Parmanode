function start_lnd {
    check_rpc_bitcoin
    please_wait
    sudo systemctl start lnd.service 
}

function stop_lnd {
    please_wait
    sudo systemctl stop lnd.service 
}

function restart_lnd {
    check_rpc_bitcoin
    sudo systemctl restart lnd.service 
}

function start_LND_loop {
local counter=0
while [[ $counter -lt 6 ]] ; do
if sudo systemctl status >/dev/null ; then return 0 ; fi
clear ; echo "Starting LND. Please wait..."
sudo systemctl start lnd.service >/dev/null
sleep 3
counter=$((counter + 1))
done
}