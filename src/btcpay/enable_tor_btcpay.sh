function enable_tor_btcpay {
clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir $macprefix/var/lib/tor/btcpay-service/" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir $macprefix/var/lib/tor/btcpay-service/" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7003 127.0.0.1:23001" \
    $macprefix/etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7003 127.0.0.1:23001" | sudo tee -a $macprefix/etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor
}

function disable_tor_btcpay {
clear
file="$macprefix/etc/tor/torrc"
sudo gsed -i "/btcpay-service/d" $file
sudo gsed -i "/7003 127/d" $file
restart_tor

}