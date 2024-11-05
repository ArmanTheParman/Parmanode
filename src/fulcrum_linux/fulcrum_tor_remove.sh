function fulcrum_tor_remove {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait
sudo gsed -i "/fulcrum-service/d" $macprefix/etc/tor/torrc
sudo gsed -i "/127.0.0.1:500001/d" $macprefix/etc/tor/torrc

sudo systemctl daemon-reload
sudo systemctl restart tor
sudo systemctl restart fulcrum.service

set_terminal
parmanode_conf_remove "fulcrum_tor"
return 0

}

