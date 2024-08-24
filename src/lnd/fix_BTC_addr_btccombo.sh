function fix_BTC_addr_btccombo {
if grep -q "lnd-" < $ic ; then
file="$HOME/.lnd/lnd.conf"
elif grep -q "litd-" <$ic ; then
file="$HOME/.lit/lit.conf"
fi


if grep -q "btccombo-end" < $ic ; then

store_BTC_container_IP
if grep -q "$BTCIP" < $file ; then return 0 ; fi

swap_string "$file" "bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332" "bitcoind.zmqpubrawblock=tcp://$BTCIP:28332"
swap_string "$file" "bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333" "bitcoind.zmqpubrawtx=tcp://$BTCIP:28333"
swap_string "$file" "bitcoind.rpchost=127.0.0.1" "bitcoind.rpchost=$BTCIP"
fi
}