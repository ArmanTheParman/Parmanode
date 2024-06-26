function enable_tor_rtl {
if [[ $OS == Mac ]] ; then announce "Tor feature not availalbe for Mac yet." ; return 1 ; fi

clear
enable_tor_general || return 1
clear
if sudo grep "HiddenServiceDir /var/lib/tor/rtl-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/rtl-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7005 127.0.0.1:3000" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7005 127.0.0.1:3000" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

parmanode_conf_add "rtl_tor=true"

sudo systemctl restart tor
}

function disable_tor_rtl {
if [[ $OS == Mac ]] ; then return 1 ; fi
clear
file="/etc/tor/torrc"

delete_line "$file" "rtl-service"
delete_line "$file" "7005 127"
parmanode_conf_remove "rtl_tor"
sudo systemctl restart tor

}