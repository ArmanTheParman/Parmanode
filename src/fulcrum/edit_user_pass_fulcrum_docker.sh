function edit_user_pass_fulcrum_podman {

nogsedtest
sudo gsed -i "/rpcuser/d" $fc
sudo gsed -i "/rpcpassword/d" $fc
echo "rpcuser = $rpcuser" >> $fc
echo "rpcpassword = $rpcpassword" >> $fc
}
