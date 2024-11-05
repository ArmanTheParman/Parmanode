function fix_BTC_addr_btccombo {
if grep -q "lnd-" < $ic ; then
file="$HOME/.lnd/lnd.conf"
elif grep -q "litd-" <$ic ; then
file="$HOME/.lit/lit.conf"
fi


if grep -q "btccombo-end" < $ic ; then

store_BTC_container_IP
if grep -q "$BTCIP" < $file ; then return 0 ; fi

sudo gsed -i "/bitcoind.zmqpubrawblock=tcp:\/\/127.0.0.1:28332/c\bitcoind.zmqpubrawblock=tcp:\/\/$BTCIP:28332" $file
sudo gsed -i "/bitcoind.zmqpubrawtx=tcp:\/\/127.0.0.1:28333/c\bitcoind.zmqpubrawtx=tcp:\/\/$BTCIP:28333" $file
sudo gsed -i "/bitcoind.rpchost=127.0.0.1/c\bitcoind.rpchost=$BTCIP" $file
fi
}