function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
jmvenv "activate"
$hp/joinmarket/scripts/obwatch/ob-watcher.py | sudo tee $HOME/.joinmarket/orderbook.log
jmvenv "deactivate"
else
kill $obwatcherPID
fi
}