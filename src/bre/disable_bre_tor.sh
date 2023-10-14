function disable_bre_tor {
if [[ $OS == "Mac" ]] ; then return 1 ; fi

delete_line "/etc/tor/torrc" "HiddenServiceDir /var/lib/tor/bre-service/"
delete_line "/etc/tor/torrc" "HiddenServicePort 3004 127.0.0.1:3002"
sudo rm -rf /var/lib/tor/bre-service
sudo systemctl restart tor

}