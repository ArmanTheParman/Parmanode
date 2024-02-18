function electrumx_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

delete_line "/etc/tor/torrc" "electrumx-service"
delete_line "/etc/tor/torrc" "127.0.0.1:50007"

sudo systemctl restart tor

set_terminal
parmanode_conf_remove "electrumx_tor"
return 0
}