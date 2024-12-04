function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
/jm/clientserver/scripts/obwatch/ob-watcher.py | sudo tee $HOME/.joinmarket/orderbook.log
else
kill $obwatcherPID
fi
}