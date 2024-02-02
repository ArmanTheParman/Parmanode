
function source_rpc_global {

#Bitcoin
if [[ -e $bc ]] ; then 
source $bc 
fi

#BRE (non docker)
if [[ -e $HOME/parmanode/btc-rpc-explorer/.env ]] ; then
export BRE_rpcuser=$(cat $HOME/parmanode/btc-rpc-explorer/.env | grep BTCEXP_BITCOIND_USER | cut -d = -f 2)
export BRE_rpcpassword=$(cat $HOME/parmanode/btc-rpc-explorer/.env | grep BTCEXP_BITCOIND_PASS | cut -d = -f 2)
fi

#BRE (docker)
if [[ -e $HOME/parmanode/bre/.env ]] ; then
export BREdocker_rpcuser=$(cat $HOME/parmanode/bre/.env | grep BTCEXP_BITCOIND_USER | cut -d = -f 2)
export BREdocker_rpcpassword=$(cat $HOME/parmanode/bre/.env | grep BTCEXP_BITCOIND_PASS | cut -d = -f 2)
fi

#LND
if [[ -e $HOME/.lnd/lnd.conf ]] ; then
export LND_rpcuser=$(cat $HOME/.lnd/lnd.conf | grep "bitcoind.rpcuser" | cut -d = -f 2)
export LND_rpcpassword=$(cat $HOME/.lnd/lnd.conf | grep "bitcoind.rpcpass" | cut -d = -f 2)
fi

#NBXplorer
if [[  -e $HOME/.nbxplorer/Main/settings.config ]] ; then
export nbxplorer_rpcuser=$(cat $HOME/.nbxplorer/Main/settings.config | grep "btc.rpc.user" | cut -d = -f 2)
export nbxplorer_rpcpassword=$(cat $HOME/.nbxplorer/Main/settings.config | grep "btc.rpc.password" | cut -d = -f 2)
fi

#electrs
if [[ -e $HOME/.electrs/config.toml ]] ; then
export electrs_rpcuser=$(cat $HOME/.electrs/config.toml | grep -Eo '^auth.*$' | cut -d : -f 1 | cut -d \" -f 2)
export electrs_rpcpassword=$(cat $HOME/.electrs/config.toml | grep -Eo '^auth.*$' | cut -d : -f 2 | cut -d \" -f 1)
fi

#fulcrum
if [[ -e $hp/fulcrum/fulcrum.conf ]] ; then
export fulcrum_rpcuser=$(cat $hp/fulcrum/fulcrum.conf | grep rpcuser | cut -d = -f 2 | tr -d '[:space:]' )
export fulcrum_rpcpassword=$(cat $hp/fulcrum/fulcrum.conf | grep rpcpassword | cut -d = -f 2 | tr -d '[:space:]' )
fi

#mempool
if [[ -e $hp/mempool/docker/docker-compose.yml ]] ; then 
export mempool_rpcuser=$(cat $hp/mempool/docker/docker-compose.yml | grep CORE_RPC_USERNAME | cut -d \" -f 2 | tr -d \" )
export mempool_rpcpassword=$(cat $hp/mempool/docker/docker-compose.yml | grep CORE_RPC_PASSWORD | cut -d \" -f 2 | tr -d \" )
fi

#sparrow
if [[ -e ~/.sparrow/config ]] ; then
export sparrow_rpcuser=$(cat ~/.sparrow/config | grep 'coreAuth"' | cut -d : -f 2 | tr -d '"[:space:]' )
export sparrow_rpcpassword=$(cat ~/.sparrow/config | grep 'coreAuth"' | cut -d : -f 3 | tr -d '"[:space:],' )
fi

}