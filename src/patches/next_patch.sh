function patch_7 {
#remove from temppatch
add_rpcbind

#log file location has changed, delete the old one.
if grep -q "electrsdkr" $ic ; then
restart_electrs
docker exec -d electrs /bin/bash -c "rm /home/parman/run_electrs.log"
fi

#no longer needed
if grep prefersbitcoinmempool_only_ask_once < $pc ; then
gsed -i "/prefersbitcoinmempool_only_ask_once/d" $pc >$dn 2>&1
fi

if [[ $OS == Linux ]] && ! which bc >$dn 2>&1 ; then
echo "${green}Installing the bc caluclator, necessary for Parmanode to think...$orange"
sudo apt-get update -y && sudo apt-get install bc
fi

#torlogging
if [[ -e $torrc ]] && ! grep -q "tornoticefile.log" $torrc ; then
echo "Log notice file $HOME/.tornoticefile.log" | sudo tee -a $torrc >$dn 2>&1
fi
if [[ -e $torrc ]] && ! grep -q "torinfofile.log" $torrc ; then
echo "Log notice file $HOME/.torinfofile.log" | sudo tee -a $torrc >$dn 2>&1
fi
#use %include in torrc for hidden services later

if [[ $OS == Mac ]] && grep -q "fulcrum-end" $ic ; then
sudo gsed -i 's/fulcrum-end/fulcrumdkr-end/' $ic >$dn 2>&1 
sudo gsed -i 's/fulcrum-start/fulcrumdkr-start/' $ic >$dn 2>&1 
fi


parmanode_conf_remove "patch="
parmanode_conf_add "patch=7"
}
