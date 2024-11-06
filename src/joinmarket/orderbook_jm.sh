function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
docker exec -d joinmarket /jm/clientserver/scripts/obwatch/ob-watcher.py | sudo tee $HOME/.joinmarket/orderbook.log >/dev/null 2>&1
else
docker exec joinmarket kill $obwatcherPID
fi
}