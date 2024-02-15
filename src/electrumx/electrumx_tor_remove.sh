function electrumx_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

delete_line "/etc/tor/torrc" "electrumx-service"
delete_line "/etc/tor/torrc" "127.0.0.1:50007"

sudo rm -rf /var/lib/tor/electrumx-service
sudo systemctl restart tor

if grep -q electrumxdkr < $dp/installed.conf ; then
docker_stop_electrumx
else
sudo systemctl stop electrumx.service 2>&1
fi

if [[ $1 != uninstall ]] ; then

    if grep -q electrumxdkr < $dp/installed.conf ; then
    docker_start_electrumx
    else
    sudo systemctl start electrumx.service

fi

set_terminal
parmanode_conf_remove "electrumx_tor"
return 0
}