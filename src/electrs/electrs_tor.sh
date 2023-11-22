function electrs_tor {

enable_tor_general || return 1

if sudo grep "HiddenServiceDir /var/lib/tor/electrs-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/electrs-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7004 127.0.0.1:50005" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true ; else
    echo "HiddenServicePort 7004 127.0.0.1:50005" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

if grep -q electrsdkr < $dp/installed.conf ; then
docker_stop_electrs
docker_start_electrs
else
sudo systemctl restart electrs.service
fi

get_onion_address_variable "electrs" >/dev/null 2>&1

parmanode_conf_add "electrs_tor=true"

echo "    Changes have been made to torrc file"
echo "    Tor has been restarted."
echo ""
enter_continue
}