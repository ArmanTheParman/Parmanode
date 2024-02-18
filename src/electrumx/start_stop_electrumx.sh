function start_electrumx {
echo "starting electrumx ..."
sudo systemctl start electrumx.service >/dev/null 2>&1

}

function stop_electrumx {
echo "stopping electrumx ..."
sudo systemctl stop electrumx.service >/dev/null 2>&1

}

function restart_electrumx {

sudo systemctl restart electrumx.service >/dev/null 2>&1

}