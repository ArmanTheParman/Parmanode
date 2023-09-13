function start_lnd {
    check_rpc_bitcoin
    sudo systemctl start lnd.service 
}

function stop_lnd {
    sudo systemctl stop lnd.service 
}

function restart_lnd {
    check_rpc_bitcoin
    sudo systemctl restart lnd.service 
}