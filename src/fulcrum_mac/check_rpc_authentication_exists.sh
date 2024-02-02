function check_rpc_authentication_exists {

if [[ ! -f $HOME/.bitcoin/bitcoin.conf ]] ; then return 1 ; fi

unset rpcuser && unset rpcpassword
source $HOME/.bitcoin/bitcoin.conf

if [[ -z $rpcuser || -z $rpcpassword ]] ; then
announce "A Bitcoin username and pasword needs to be set in bitcoin.conf"
clear
set_rpc_authentication s 
fi
add_userpass_to_fulcrum #works on non-docker too.
}