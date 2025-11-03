#marked for deletion
function edit_user_pass_fulcrum_conf {
source $pc
[[ $configure_bitcoin_self == "true" ]] && announce "Must be done manually because you imported your own Bitcoin installation." && return 1

#should work for docker and non-docker
unset rpcuser rpcpassword
source $HOME/.bitcoin/bitcoin.conf >$dn 2>&1

sudo gsed -i "/rpcuser/d" $fc
sudo gsed -i "/rpcpassword/d" $fc

if [[ -n $rpcuser ]] ; then
echo "rpcuser = $rpcuser" | sudo tee -a $fc >$dn 2>&1
fi

if [[ -n $rpcpassword ]] ; then
echo "rpcpassword = $rpcpassword" | sudo tee -a $fc >$dn 2>&1 
fi

return 0
}