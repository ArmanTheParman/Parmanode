function check_rpc_authentication_exists {
unset rpcuser && unset rpcpassword
debug1 "user pass is, before source and before if: $rpcuser $password"
source $HOME/.bitcoin/bitcoin.conf

if [[ -z $rpcuser || -z $rpcpassword ] ; then
debug1 "user/pass string empty. calling set rpc authentication"
set_rpc_authentication
else
debug1 "user/pass is not empty: $rpcuser and $rpcpassword"
fi
return 0
}