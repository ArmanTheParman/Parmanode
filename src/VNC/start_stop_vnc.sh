function start_vnc {
    sudo systemctl start vnc.service noVNC.service >$dn 2>&1
}
function stop_vnc {
    sudo systemctl stop vnc.service noVNC.service >$dn 2>&1
}
function restart_vnc {
    sudo systemctl restart vnc.service noVNC.service >$dn 2>&1
}

