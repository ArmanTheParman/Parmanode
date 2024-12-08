function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
NODAEMON="true"
pn_tmux "$hp/joinmarket/jmvenv/bin/activate ;
$hp/joinmarket/scripts/obwatch/ob-watcher.py | tee $HOME/.joinmarket/orderbook.log ;
deactivate ; " "obw"
enter_continue "pause"
start_socat joinmarket

else 
kill $obwatcherPID 
stop_socat joinmarket
fi
}