function check_rpc_authentication_exists {

if [[ ! -f $HOME/.bitcoin/bitcoin.conf ]] ; then return 1 ; fi

unset rpcuser && unset rpcpassword
source $HOME/.bitcoin/bitcoin.conf

if [[ -z $rpcuser || -z $rpcpassword ]] ; then
announce "A Bitcoin username and pasword needs to be set in bitcoin.conf"
clear
set_rpc_authentication s fulcrum
add_userpass_to_fulcrum
else

edit_user_pass_fulcrum_docker #works on non-docker too.

fi
return 0
}