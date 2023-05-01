function check_rpc_authentication_exists {

source $HOME/.bitcoin/bitcoin.conf

if [ -z $rpcuser || -z $rpcpassword ] ; then
debug1 "user/pass string empty. calling set rpc authentication"
set_rpc_authentication
fi
return 0
}