function start_electrumx {
sudo systemctl start electrumx.service
sleep 0.5

}

function stop_electrumx {
sudo systemctl stop electrumx.service
sleep 0.5

}

function restart_electrumx {
sudo systemctl restart electrumx.service
sleep 0.5
}