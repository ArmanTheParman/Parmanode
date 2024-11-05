function bre_docker_modify_env {
#docker dir for env uses bre, but non docker uses btc-rpc-explorer dir - backwards, and should
#be changed in a future version.

unset file && local file="$HOME/parmanode/bre/.env"

#computer speed question
if [[ $fast_computer == no ]] ; then
    gsed -i '' "/BTCEXP_SLOW_DEVICE_MODE=false/c\\BTCEXP_SLOW_DEVICE_MODE=true" $file
fi #else leave that configuration alone

#Sort out connection security method
unset rpcuser rpcpassword
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
if [[ -z $rpcuser || -z $rpcpassword ]] ; then  
    gsed -i "/BITCOIND_USER/d" $file 
    gsed -i "/BTCEXP_BITCOIND_PASS/d" $file
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" | tee -a $file >/dev/null 2>&1
else

    #don't use -i option, problematic with Macs
    gsed -i "s/parman/$rpcuser/"     $file 
    gsed -i "s/hodl/$rpcpassword/"   $file 

    if [[ $computer_type == Pi ]] ; then
    sed -i "s/host.docker.internal/127.0.0.1/" $file >/dev/null 2>&1
    fi

fi
}