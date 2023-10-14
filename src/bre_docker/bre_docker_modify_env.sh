function bre_docker_modify_env {
local file="$HOME/parmanode/bre/.env"

source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

cd $HOME/parmanode/bre/

if [[ $fast_computer == no ]] ; then
swap_string "$file" "BTCEXP_SLOW_DEVICE_MODE=false" "BTCEXP_SLOW_DEVICE_MODE=true"
fi



}