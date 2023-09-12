function start_electrs {
sudo systemctl start electrs.service
}

function stop_electrs {
    sudo systemctl stop electrs.service
}

function restart_electrs {
    sudo systemctl restart electrs.service
}