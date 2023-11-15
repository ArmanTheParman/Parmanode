function make_btcrpcexplorer_config {
unset file && local file="$HOME/parmanode/btc-rpc-explorer/.env"
source ~/.bitcoin/bitcoin.conf >/dev/null
source ~/.parmanode/parmanode.conf >/dev/null
eserver1="tcp://127.0.0.1:50001"
eserver2="tcp://127.0.0.1:50005" 

if [[ $fast_computer == "yes" ]] ; then
    echo "BTCEXP_SLOW_DEVICE_MODE=false" > $file 
else
    echo "BTCEXP_SLOW_DEVICE_MODE=true" > $file
fi
if [[ $btc_authentication == "user/pass" ]] ; then
    echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $file
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $file
else
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" >> $file
fi

echo "BTCEXP_BITCOIND_RPC_TIMEOUT=50000" >> $file
echo "BTCEXP=0.0.0.0" >> $file
echo "BTCEXP_ADDRESS_API=electrumx" >> $file
echo "BTCEXP_ELECTRUMX_SERVERS=$eserver1" >> $file
echo "BTCEXP_ELECTRUMX_SERVERS=$eserver2" >> $file
echo "BTCEXP_NO_RATES=false" >> $file
}

