function patch_7 {

#remove from temppatch
gsed_symlink ; add_rpcbind

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
}
