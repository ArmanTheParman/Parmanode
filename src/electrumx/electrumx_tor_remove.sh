function electrumx_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

sudo gsed -i "/electrumx-service/d" $macprefix/etc/tor/torrc
sudo gsed -i "/127.0.0.1:50007/d" $macprefix/etc/tor/torrc

sudo systemctl restart tor

set_terminal
parmanode_conf_remove "electrumx_tor"
return 0
}