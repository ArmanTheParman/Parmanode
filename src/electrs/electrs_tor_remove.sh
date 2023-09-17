function electrs_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

delete_line "/etc/tor/torrc" "electrs-service"
delete_line "/etc/tor/torrc" "127.0.0.1:50005"

sudo rm -rf /var/lib/tor/electrs*
sudo systemctl restart tor
sudo systemctl restart electrs.service

set_terminal
parmanode_conf_remove "electrs-tor"
echo "
Electrs changes have been made and the program has been restarted."
enter_continue
return 0

}