function start_vnc {
    sudo systemctl start vnc.service novnc.service >$dn 2>&1
}
function stop_vnc {
    sudo systemctl stop vnc.service novnc.service >$dn 2>&1
}
function restart_vnc {
    sudo systemctl restart vnc.service novnc.service >$dn 2>&1
}

