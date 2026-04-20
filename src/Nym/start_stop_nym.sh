function start_nym {
    nohup $hp/nym/Nym*AppImage >$dn 2>&1 &
}

function stop_nym {
    sudo pkill NymVPN*
}