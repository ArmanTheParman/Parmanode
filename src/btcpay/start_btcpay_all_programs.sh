function start_btcpay_all_programs {

clear
please_wait 

if [[ $OS == "Mac" ]] ; then
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
start_btcpay_all_programs ||  announce "error in restarting all btcpay container programs"
}

function start_btcpay_tor_indocker {
docker exec -du root btcpay tor
}