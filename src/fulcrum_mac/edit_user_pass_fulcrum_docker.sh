function edit_user_pass_fulcrum_docker {
#from the host machine
source $HOME/.bitcoin/bitcoin.conf
rpcuser="$1"

rpcpassword="$2"

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"

echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf

echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf

return 1 
}