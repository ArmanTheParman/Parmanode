function fulcrum_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

delete_line "/etc/tor/torrc" "fulcrum-service"
delete_line "/etc/tor/torrc" "127.0.0.1:50001"

sudo rm -rf /var/lib/tor/fulcrum*
sudo systemctl restart tor
sudo systemctl restart fulcrum.service

set_terminal
parmanode_conf_remove "fulcrum_tor"
return 0

}

