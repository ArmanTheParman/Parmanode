function enable_tor_rtl {

enable_tor_general || return 1

if sudo grep "HiddenServiceDir /var/lib/tor/rtl-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/rtl-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7005 127.0.0.1:3000" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7005 127.0.0.1:3000" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

}