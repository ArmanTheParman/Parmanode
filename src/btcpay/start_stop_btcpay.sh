function start_btcpay {

clear
please_wait 

if ! podman ps >$dn 2>&1 ; then
announce "Docker not running! Please start it."
return 1
fi

if ! podman ps >$dn 2>&1 | grep -q "btcpay" ; then
podman start btcpay
fi

if [[ $1 == container ]] ; then return 0 ; fi

if grep -q "btccombo" $ic ; then
    start_bitcoin_inpodman 
    start_btcpay_tor_inpodman 
fi

start_postgres_btcpay_inpodman 
sleep 2 
start_nbxplorer_inpodman
sleep 2 
start_btcpay_inpodman 

}

function stop_btcpay {
set_terminal
please_wait
podman stop btcpay 
}

function restart_btcpay {
stop_btcpay  
start_btcpay ||  announce "Error in restarting all btcpay container programs"
}

function start_btcpay_tor_inpodman {
podman exec -du root btcpay tor
}