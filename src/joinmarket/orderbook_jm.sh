function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
pn_tmux "$hp/joinmarket/jmvenv/bin/activate ;
$hp/joinmarket/scripts/obwatch/ob-watcher.py | tee $HOME/.joinmarket/orderbook.log ;
deactivate ; " "obw"

start_socat joinmarket

else 
kill $obwatcherPID 
stop_socat joinmarket
fi
}