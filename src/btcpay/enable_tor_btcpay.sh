function enable_tor_btcpay {
if [[ $OS == Mac ]] ; then announce "Tor feature not availalbe for Mac yet." ; return 1 ; fi

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir /var/lib/tor/btcpay-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/btcpay-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7003 127.0.0.1:23001" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7003 127.0.0.1:23001" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor
}

function disable_tor_btcpay {
if [[ $OS == Mac ]] ; then return 1 ; fi
clear
file="/etc/tor/torrc"

delete_line "$file" "btcpay-service"
delete_line "$file" "7003 127"
sudo systemctl restart tor

}