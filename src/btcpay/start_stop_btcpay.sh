function start_btcpay {
    
if [[ $OS == "Linux" ]] ; then
    if [[ $1 != pw ]] ; then #use pw with restart_btcpay to no repeat "please wait"
    set_terminal
    please_wait
    fi
fi

if [[ $OS == "Linux" ]] ; then
startup_postgres && run_nbxplorer && run_btcpay
elif [[ $OS == "Mac" ]] ; then
start_bitcoin_docker && startup_postgres && run_nbxplorer && run_btcpay && run_btcpay_tor
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
stop_btcpay pw
start_btcpay pw
}

function run_btcpay_tor {
docker exec -du root btcpay tor
}