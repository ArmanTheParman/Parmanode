function edit_user_pass_fulcrum_docker {
    
if [[ $3 != remote ]] ; then # $3 used in function fulcrum_to_remote
#from the host machine
source $bc
fi
sudo gsed -i "/rpcuser/d" $fc
sudo gsed -i "/rpcpassword/d" $fc
echo "rpcuser = $rpcuser" >> $fc
echo "rpcpassword = $rpcpassword" >> $fc
}
