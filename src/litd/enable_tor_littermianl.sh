function enable_tor_litterminal {
if [[ $OS == Mac ]] ; then announce "Tor feature not availalbe for Mac yet." ; return 1 ; fi

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir /var/lib/tor/litterminal-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/litterminal-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7007 127.0.0.1:8443" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7007 127.0.0.1:8443" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor
}

function disable_tor_litterminal {
if [[ $OS == Mac ]] ; then return 1 ; fi
clear
file="/etc/tor/torrc"

delete_line "$file" "litterminal-service"
delete_line "$file" "7007 127"
sudo systemctl restart tor

}