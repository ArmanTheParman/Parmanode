function check_rpc_authentication_exists {

source $HOME/.bitcoin/bitcoin.conf

if [ -z $rpcuser || -z $rpcpassword ] ; then
set_rpc_authentication
fi
return 0
}