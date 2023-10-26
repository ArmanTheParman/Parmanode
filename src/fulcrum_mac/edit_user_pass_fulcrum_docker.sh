function edit_user_pass_fulcrum_docker {
    
if [[ $3 != remote ]] ; then # $3 used in function fulcrum_to_remote
#from the host machine
source $HOME/.bitcoin/bitcoin.conf
fi

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"

echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf

echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
}
