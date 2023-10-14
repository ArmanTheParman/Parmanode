function bre_docker_modify_env {
local file="$HOME/parmanode/bre/.env"

#computer speed question
bre_computer_speed
if [[ $fast_computer == no ]] ; then
swap_string "$file" "BTCEXP_SLOW_DEVICE_MODE=false" "BTCEXP_SLOW_DEVICE_MODE=true"
fi #else leave that configuration alone

#Sort out connection method
unset rpcuser rpcpassword
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
if [[ -n rpcuser && -n rpcpassword ]] ; then  
cd $HOME/parmanode/bre/
sed !BITCOIND_USER=!d ./.env 


}