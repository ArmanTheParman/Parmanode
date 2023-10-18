function bre_docker_modify_env {
local file="$HOME/parmanode/bre/.env"

#computer speed question
if [[ $fast_computer == no ]] ; then
    if [[ $OS == Mac   ]] ; then sed -i '' "/BTCEXP_SLOW_DEVICE_MODE=false/c\\BTCEXP_SLOW_DEVICE_MODE=true" $file ; fi
    if [[ $OS == Linux ]] ; then sed -i    "/BTCEXP_SLOW_DEVICE_MODE=false/c\\BTCEXP_SLOW_DEVICE_MODE=true" $file ; fi
fi #else leave that configuration alone

#Sort out connection security method
unset rpcuser rpcpassword
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
if [[ -z rpcuser || -z rpcpassword ]] ; then  

    delete_line "$file" "BITCOIND_USER" 
    delete_line "$file" "BTCEXP_BITCOIND_PASS"
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" | tee -a $file >/dev/null 2>&1
else

    #don't use -i option, problematic with Macs
    if [[ $OS == Mac ]] ; then
    sed "s/parman/$rpcuser/"     $file > $file-2 && mv $file-2 $file
    sed "s/hodl/$rpcpassword/"   $file > $file-2 && mv $file-2 $file
    fi

    if [[ $OS == Linux ]] ; then
    sed -i "s/parman/$rpcuser/"     $file 
    sed -i "s/hodl/$rpcpassword/"   $file 
    fi

fi
}