function start_electrs { #non-docker function
source $pc
if [[ $disable_electrs == "true" ]] ; then return 1 ; fi

please_wait
if [[ $OS == Linux ]] ; then 
    sudo systemctl start electrs.service >$dn 2>&1
fi

if [[ $OS == Mac ]] ; then
    #/dev/null here is intentional and suppresses output
    #script -q /dev/null  $HOME/parmanode/electrs/target/release/electrs --conf $HOME/.electrs/config.toml >> $HOME/.parmanode/run_electrs.log 2>&1 &
    nohup $HOME/parmanode/electrs/target/release/electrs --conf $HOME/.electrs/config.toml > $HOME/.electrs/run_electrs.log 2>&1 &
    start_socat electrs
fi

}

function stop_electrs {
please_wait
if [[ $OS == Linux ]] ; then sudo systemctl stop electrs.service ; fi
if [[ $OS == Mac ]] ; then pkill -INT electrs ; stop_socat electrs ; fi
}

function restart_electrs {
source $pc
if [[ $disable_electrs == "true" ]] ; then return 1 ; fi
please_wait
if [[ $OS == Linux ]] ; then sudo systemctl restart electrs.service ; fi 
if [[ $OS == Mac ]] ; then stop_electrs ; start_electrs ; fi
}