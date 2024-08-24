function make_lnd_service_tor {

if ! which tor > $dn 2>&1 ; then return 0 ; fi

if [[ $OS == Linux ]] ; then

    if grep -q "7008" < /etc/torrc ; then return 0 ; fi

    echo "
HiddenServiceDir /var/lib/tor/lnd-service
HiddenServicePort 7008 127.0.0.1:8080
" | sudo tee -a /etc/torrc

else

    if grep -q "7008" < /usr/local/etc/torrc ; then return 0 ; fi

    echo "
HiddenServiceDir /usr/local/var/lib/tor/lnd-service
HiddenServicePort 7008 127.0.0.1:8080
" | sudo tee -a /etc/torrc

fi

}
