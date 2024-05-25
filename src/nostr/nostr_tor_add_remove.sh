function nostr_tor_add {
enable_tor_general || return 1

if sudo grep "HiddenServiceDir /var/lib/tor/nostr-service/" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true 
    else 
    echo "HiddenServiceDir /var/lib/tor/nostr-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep "HiddenServicePort 7081 127.0.0.1:7080" \
    /etc/tor/torrc | grep -v "^#" >/dev/null 2>&1 ; then true 
    else
    echo "HiddenServicePort 7081 127.0.0.1:7080" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

sudo systemctl restart tor

}

function nostr_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

please_wait

delete_line "/etc/tor/torrc" "nostr-service"
delete_line "/etc/tor/torrc" "127.0.0.1:7080"

sudo systemctl restart tor

set_terminal
}