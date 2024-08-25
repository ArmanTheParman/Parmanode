function make_lnd_service_tor {

if ! which tor > $dn 2>&1 ; then return 0 ; fi

if [[ $OS == Linux ]] ; then

    if [[ ! -e /etc/tor/torrc ]] ; then return 1 ; fi
    if grep -q "7008" < /etc/tor/torrc >/dev/null 2>&1 ; then return 0 ; fi

    echo "HiddenServiceDir /var/lib/tor/lnd-service
HiddenServicePort 7008 127.0.0.1:8080
" | sudo tee -a /etc/tor/torrc >$dn 2>&1
    restart_tor
else
    if [[ ! -e /usr/local/etc/tor/torrc ]] ; then return 1 ; fi
    if grep -q "7008" < /usr/local/etc/tor/torrc >/dev/null 2>&1 ; then return 0 ; fi

    echo "HiddenServiceDir /usr/local/var/lib/tor/lnd-service
HiddenServicePort 7008 127.0.0.1:8080
" | sudo tee -a /usr/local/etc/tor/torrc >$dn 2>&1
    restart_tor
fi

}
