function start_electrs {

please_wait
if [[ $OS == Linux ]] ; then 
    if ! pgrep bitcoind >/dev/null 2>&1 ; then
    announce "Please make sure Bitcoin is running or electrs can't start" 
    else
    sudo systemctl start electrs.service 
    fi
fi
if [[ $OS == Mac ]] ; then
    if ! pgrep Bitcoin-Q >/dev/null ; then 
    announce "Please make sure Bitcoin is running or electrs can't start" 
    else
    $HOME/parmanode/electrs/target/release/electrs --conf $HOME/.electrs/config.toml > $HOME/.parmanode/run_electrs.log 2>&1 &
    fi
fi
}

function stop_electrs {
please_wait
if [[ $OS == Linux ]] ; then sudo systemctl stop electrs.service ; fi
if [[ $OS == Mac ]] ; then pkill -INT electrs ; fi
}

function restart_electrs {
please_wait
if [[ $OS == Linux ]] ; then sudo systemctl restart electrs.service ; fi 
if [[ $OS == Mac ]] ; then stop_electrs ; start_electrs ; fi
}