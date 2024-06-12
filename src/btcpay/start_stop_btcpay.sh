function start_btcpay {
    
if [[ $OS == "Linux" ]] ; then
    if [[ $1 != pw ]] ; then #use pw with restart_btcpay to no repeat "please wait"
    set_terminal
    please_wait
    fi
fi

if [[ $OS == "Linux" ]] ; then
startup_postgres || log "debug" "startup_postregs error" 
run_nbxplorer || log "debug" "run_nbxplorer error" 
run_btcpay  || log "debug" "run_btcpay error"
elif [[ $OS == "Mac" ]] ; then
start_bitcoin_docker || log "debug" "start_bitcoin_docker error"
startup_postgres || log "debug" "startup_postregs error"
sleep 2 
run_nbxplorer || log "debug" "run_nbxplorer error"
sleep 2 
run_btcpay  || log "debug" "run_btcpay error"
run_btcpay_tor | log "debug" "run_btcpay_tor error"
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
start_btcpay pw || log "debug" "start_btcpay pw error"
}

function run_btcpay_tor {
docker exec -du root btcpay tor
}