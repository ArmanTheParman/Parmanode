function start_electrumx {

sudo systemctl start electrumx.service >/dev/null 2>&1

}

function stop_electrumx {

sudo systemctl stop electrumx.service >/dev/null 2>&1

}

function restart_electrumx {

sudo systemctl restart electrumx.service >/dev/null 2>&1

}