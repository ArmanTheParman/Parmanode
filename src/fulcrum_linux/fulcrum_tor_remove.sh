function fulcrum_tor_remove {

please_wait
sudo gsed -i "/fulcrum-service/d" $macprefix/etc/tor/torrc >$dn 2>&1
sudo gsed -i "/127.0.0.1:50001/d" $macprefix/etc/tor/torrc >$dn 2>&1

sudo systemctl daemon-reload >$dn 2>&1
sudo systemctl restart tor >$dn 2>&1
sudo systemctl restart fulcrum.service >$dn 2>&1

set_terminal
parmanode_conf_remove "fulcrum_tor"
return 0

}

