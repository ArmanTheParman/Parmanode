function start_electrs { #non-docker function

please_wait
if [[ $OS == Linux ]] ; then 
    sudo systemctl start electrs.service 
fi
if [[ $OS == Mac ]] ; then
    script -q /dev/null  $HOME/parmanode/electrs/target/release/electrs --conf $HOME/.electrs/config.toml >> $HOME/.parmanode/run_electrs.log 2>&1 &
fi
}
########################################################################################
function stop_electrs {
please_wait
if [[ $OS == Linux ]] ; then sudo systemctl stop electrs.service ; fi
if [[ $OS == Mac ]] ; then pkill -INT electrs ; fi
}
########################################################################################
function restart_electrs {
please_wait
if [[ $OS == Linux ]] ; then sudo systemctl restart electrs.service ; fi 
if [[ $OS == Mac ]] ; then stop_electrs ; start_electrs ; fi
}