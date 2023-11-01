function start_btcpay {
if [[ $OS == "Linux" ]] ; then
    if [[ $1 != pw ]] ; then #use pw with restart_btcpay to no repeat "please wait"
    set_terminal
    please_wait
    fi
docker start btcpay
startup_postgres && \
run_nbxplorer && \
run_btcpay
fi
}

function stop_btcpay {
    if [[ $1 != pw ]] ; then
    set_terminal
    please_wait
    fi
if [[ $OS == "Linux" ]] ; then docker stop btcpay ; fi
}

function restart_btcpay {
set_terminal
please_wait
stop_btcpay pw
start_btcpay pw
}