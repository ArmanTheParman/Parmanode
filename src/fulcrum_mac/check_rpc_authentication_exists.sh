function check_rpc_authentication_exists {

if [[ ! -f $HOME/.bitcoin/bitcoin.conf ]] ; then return 1 ; fi

unset rpcuser && unset rpcpassword
source $HOME/.bitcoin/bitcoin.conf

if [[ -z $rpcuser || -z $rpcpassword ]] ; then
set_rpc_authentication
else

if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; fi

fi
return 0
}