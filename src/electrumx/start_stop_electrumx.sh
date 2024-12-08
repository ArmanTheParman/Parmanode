function start_electrumx {
sudo -v
pn_tmux "sudo systemctl start electrumx.service"
sleep 0.5

}

function stop_electrumx {
sudo -v
pn_tmux "sudo systemctl stop electrumx.service"
sleep 0.5

}

function restart_electrumx {
sudo -v
pn_tmux "sudo systemctl restart electrumx.service"
sleep 0.5
}