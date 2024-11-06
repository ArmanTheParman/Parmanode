function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
docker exec -d joinmarket /bin/bash -c '/jm/clientserver/scripts/obwatch/ob-watcher.py | sudo tee /root/.joinmarket/orderbook.log'
else
docker exec joinmarket kill $obwatcherPID
fi
}