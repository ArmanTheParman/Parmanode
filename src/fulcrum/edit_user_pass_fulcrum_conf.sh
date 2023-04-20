function edut_user_pass_fulcrum_conf {

rpcuser=$(grep -w "rpcuser" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')

rpcpassword=$(grep -w "rpcpassword" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"

echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf

echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf

return 0
}