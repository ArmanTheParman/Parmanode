function start_btcpay {

clear
please_wait 

if ! docker ps >$dn 2>&1 ; then
announce "Docker not running! Please start it."
return 1
fi

if ! docker ps >$dn 2>&1 | grep -q "btcpay" ; then
docker start btcpay
fi

if [[ $1 == container ]] ; then return 0 ; fi

if grep -q "btccombo" $ic ; then
    start_bitcoin_indocker 
    start_btcpay_tor_indocker 
fi

start_postgres_btcpay_indocker 
sleep 2 
start_nbxplorer_indocker
sleep 2 
start_btcpay_indocker 

}

function stop_btcpay {
set_terminal
please_wait
docker stop btcpay 
}

function restart_btcpay {
stop_btcpay  
start_btcpay ||  announce "Error in restarting all btcpay container programs"
}

function start_btcpay_tor_indocker {
docker exec -du root btcpay tor
}