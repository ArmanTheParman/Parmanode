function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
    pn_tmux "source $hp/joinmarket/jmvenv/bin/activate ;
    $hp/joinmarket/scripts/obwatch/ob-watcher.py | tee $HOME/.joinmarket/orderbook.log ;
    deactivate ; " "obw"
    start_socat joinmarket
    jm_log_file_manager  # keeps log file managable in size
else 
    kill $obwatcherPID 
    stop_socat joinmarket
    jm_log_file_manager stop
fi
}