function start_electrumx {
echo "starting electrumx ..."
sudo systemctl start electrumx.service >$dn 2>&1

}

function stop_electrumx {
echo "stopping electrumx ..."
sudo systemctl stop electrumx.service >$dn 2>&1

}

function restart_electrumx {

sudo systemctl restart electrumx.service >$dn 2>&1

}