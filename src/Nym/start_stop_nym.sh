function start_nym {
    sudo systemctl start nym-vpnd.service >$dn 2>&1
    nohup $hp/nym/Nym*AppImage >$dn 2>&1 &
    announce "Nym started"
}

function stop_nym {
    sudo systemctl stop nym-vpnd.service >$dn 2>&1
    sudo pkill nym-vpn-app >$dn 2>&1
    sudo systemctl stop nym-vpn >$dn 2>&1
    announce "Nym stopped"
}