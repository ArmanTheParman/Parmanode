function edit_user_pass_fulcrum_docker {
#from the host machine
source $HOME/.bitcoin/bitcoin.conf

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"

echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf

echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
}
