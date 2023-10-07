function fix_lnd_service {

if grep -q "Wants=bitcoind.service" < /etc/systemd/system/lnd.service ; then

    if sudo systemctl status lnd.service >/dev/null 2>&1 ; then running=true ; sudo systemctsl stop lnd.service >/dev/null 2>&1 ; fi

    swap_string "/etc/systemd/system/lnd.service" "Wants=bitcoind.service" "BindsTo=bitcoind.service" && \
    sudo systemctl daemon-reload >/dev/null 2>&1 
    if [[ $running == true ]] ; then sudo systemctl start lnd.service >/dev/null 2>&1 ; fi

fi
}