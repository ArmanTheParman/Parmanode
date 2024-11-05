function disable_bre_tor {
if [[ $OS == "Mac" ]] ; then return 1 ; fi

sudo gsed -i "/HiddenServiceDir \/var\/lib\/tor\/bre-service/d" "$macprefix/etc/tor/torrc"
sudo gsed -i "/HiddenServicePort 3004 127.0.0.1:3002/d" "$macprefix/etc/tor/torrc"

sudo systemctl restart tor

}