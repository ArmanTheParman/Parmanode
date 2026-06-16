function start_cln {
    sudo systemctl start core-lightning.service >$dn 2>&1
}
function stop_cln {
    sudo systemctl stop core-lightning.service >$dn 2>&1
}
function restart_cln {
    stop_cln
    start_cln
}
