function electrs_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

sudo gsed -i "/electrs-service/d" $macprefix/etc/tor/torrc
sudo gsed -i "/127.0.0.1:50005/d" $macprefix/etc/tor/torrc

if [[ $1 != uninstall ]] ; then sudo systemctl restart tor ; fi

set_terminal
parmanode_conf_remove "electrs_tor"
return 0
}