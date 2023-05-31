function check_rpc_authentication_exists {
#in case there is a password in memory, and that's not current
#with bitcoin.conf, must unset first, otherwise if bitcoin.conf
#is empty, old password will stay in memory...

unset rpcuser && unset rpcpassword
source $HOME/.bitcoin/bitcoin.conf

if [[ -z $rpcuser || -z $rpcpassword ]] ; then
set_rpc_authentication
else

if [[ $OS == "Mac" ]] ; then edit_user_pass_fulcrum_docker ; fi

fi
return 0
}