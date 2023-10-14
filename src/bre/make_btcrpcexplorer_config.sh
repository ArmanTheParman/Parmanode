function make_btcrpcexplorer_config {

source ~/.bitcoin/bitcoin.conf >/dev/null
source ~/.parmanode/parmanode.conf >/dev/null

if cat ~/.parmanode/installed.conf | grep -q electrs-end ; then eserver="tcp://127.0.0.1:50005" 
else eserver="tcp://127.0.0.1:50001"
fi

if [[ $fast_computer == "yes" ]] ; then
    echo "BTCEXP_SLOW_DEVICE_MODE=false" > $HOME/parmanode/btc-rpc-explorer/.env 
else
    echo "BTCEXP_SLOW_DEVICE_MODE=true" > $HOME/parmanode/btc-rpc-explorer/.env 
fi
if [[ $btc_authentication == "user/pass" ]] ; then
    echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $HOME/parmanode/btc-rpc-explorer/.env 
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $HOME/parmanode/btc-rpc-explorer/.env 
else
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" >> $HOME/parmanode/btc-rpc-explorer/.env 
fi

echo "BTCEXP_BITCOIND_RPC_TIMEOUT=50000" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP=0.0.0.0" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_ADDRESS_API=electrumx" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_ELECTRUMX_SERVERS=$eserver" >> $HOME/parmanode/btc-rpc-explorer/.env 
echo "BTCEXP_NO_RATES=false" >> $HOME/parmanode/btc-rpc-explorer/.env 
}

