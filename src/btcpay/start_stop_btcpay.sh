function start_btcpay_all_programs {
    
if [[ $OS == "Linux" ]] ; then
    if [[ $1 != pw ]] ; then #use pw with start_btcpay_all_programs to no repeat "please wait"
    set_terminal
    please_wait
    fi
fi

if [[ $OS == "Linux" ]] ; then
startup_postgres 
start_nbxplorer_indocker
start_btcpay_indocker  
elif [[ $OS == "Mac" ]] ; then
start_bitcoin_indocker 
startup_postgres 
sleep 2 
start_nbxplorer_indocker
sleep 2 
start_btcpay_indocker 
start_btcpay_tor_indocker 
fi

}

function stop_btcpay {
    if [[ $1 != pw ]] ; then
    set_terminal
    please_wait
    fi

docker stop btcpay 
}

function restart_btcpay {
set_terminal
please_wait
stop_btcpay pw || log "debug" "stop_btcpay pw error"
start_btcpay_all_programs pw || log "debug" "start_btcpay_all_programs pw error"
}

function start_btcpay_tor_indocker {
docker exec -du root btcpay tor
}