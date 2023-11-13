function electrs_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

delete_line "/etc/tor/torrc" "electrs-service"
delete_line "/etc/tor/torrc" "127.0.0.1:50005"

sudo rm -rf /var/lib/tor/electrs-service
sudo systemctl restart tor

if grep -q electrsdkr < $dp/installed.conf ; then
docker_stop_electrs
docker_start_electrs
else
sudo systemctl restart electrs.service
fi

set_terminal
parmanode_conf_remove "electrs_tor"
return 0
}