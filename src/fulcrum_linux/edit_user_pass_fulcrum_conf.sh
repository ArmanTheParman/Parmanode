#marked for deletion
function edit_user_pass_fulcrum_conf {
#should work for docker and non-docker
unset rpcuser rpcpassword
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1

sudo gsed -i "/rpcuser/d" $fc
sudo gsed -i "/rpcpassword/d" $fc

if [[ -n $rpcuser ]] ; then
echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf
fi

if [[ -n $rpcpassword ]] ; then
echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf
fi

return 0
}