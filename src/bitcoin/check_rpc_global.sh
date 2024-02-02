function measure_rpc_global {

#bitcoin
if [[ -e $bc ]] ; then 
source $bc 
echo "bitcoin rpcuser=$rpcuser rpcpassword=$rpcpassword" > $dp/.global
unset rpcuser rpcpassword
fi

#BRE (non docker)
if [[ -e $HOME/parmanode/btc-rpc-explorer/.env ]] ; then
rpcuser=$(cat $HOME/parmanode/btc-rpc-explorer/.env | grep BTCEXP_BITCOIND_USER | cut -d = -f 2)
rpcpassword=$(cat $HOME/parmanode/btc-rpc-explorer/.env | grep BTCEXP_BITCOIND_PASS | cut -d = -f 2)
echo "BRE rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
fi

#BRE (docker)
if [[ -e $HOME/parmanode/bre/.env ]] ; then
rpcuser=$(cat $HOME/parmanode/btc-rpc-explorer/.env | grep BTCEXP_BITCOIND_USER | cut -d = -f 2)
rpcpassword=$(cat $HOME/parmanode/btc-rpc-explorer/.env | grep BTCEXP_BITCOIND_PASS | cut -d = -f 2)
echo "BREdocker rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
fi

#LND
if [[ -e $HOME/.lnd/lnd.conf ]] ; then
rpcuser=$(cat $HOME/.lnd/lnd.conf | grep "bitcoind.rpcuser" | cut -d = -f 2)
rpcpassword=$(cat $HOME/.lnd/lnd.conf | grep "bitcoind.rpcpass" | cut -d = -f 2)
echo "LND rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
unset rpcuser rpcpassword
fi

#NBXplorer
if [[  -e $HOME/.nbxplorer/Main/settings.config ]] ; then
rpcuser=$(cat $HOME/.nbxplorer/Main/settings.config | grep "btc.rpc.user" | cut -d = -f 2)
rpcpassword=$(cat $HOME/.nbxplorer/Main/settings.config | grep "btc.rpc.password" | cut -d = -f 2)
echo "nbxplorer rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
unset rpcuser rpcpassword
fi

#electrs
if [[ -e $HOME/.electrs ]] ; then
rpcuser=$(cat $HOME/.electrs/config.toml | grep -Eo '^auth.*$' | cut -d : -f 1 | cut -d \" -f 2)
rpcpassword=$(cat $HOME/.electrs/config.toml | grep -Eo '^auth.*$' | cut -d : -f 2 | cut -d \" -f 1)
echo "electrs rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
unset rpcuser rpcpassword
fi

#fulcrum
if [[ -e $hp/fulcrum/fulcrum.conf ]] ; then
rpcuser=$(cat $hp/fulcrum/fulcrum.conf | grep rpcuser | cut -d = -f 2 | tr -d '[:space:]' )
rpcpassword=$(cat $hp/fulcrum/fulcrum.conf | grep rpcpassword | cut -d = -f 2 | tr -d '[:space:]' )
echo "fulcrum rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
unset rpcuser rpcpassword
fi

#mempool
if [[ -e $hp/mempool/docker/docker-compose.yml ]] ; then 
rpcuser=$(cat $hp/mempool/docker/docker-compose.yml | grep CORE_RPC_USERNAME | cut -d \" -f 2 | tr -d \" )
rpcpassword=$(cat $hp/mempool/docker/docker-compose.yml | grep CORE_RPC_PASSWORD | cut -d \" -f 2 | tr -d \" )
echo "mempool rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
unset rpcuser rpcpassword
fi

#sparrow
if [[ -e ~/.sparrow/config ]] ; then
rpcuser=$(cat ~/.sparrow/config | grep 'coreAuth"' | cut -d : -f 2 | tr -d '"[:space:]' )
rpcpassword=$(cat ~/.sparrow/config | grep 'coreAuth"' | cut -d : -f 3 | tr -d '"[:space:],' )
echo "sparrow rpcuser=$rpcuser rpcpassword=$rpcpassword" >> $dp/.global
unset rpcuser rpcpassword
fi

}