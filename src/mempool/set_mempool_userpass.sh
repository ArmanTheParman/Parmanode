function set_mempool_userpass {
if ! docker ps | grep docker-api-1 ; then
set_terminal ; echo "mempool container not running; can't update bitcoin rpc password. Abandoning."
enter_continue
return 1
fi

source $HOME/.bitcoin/bitcoin.conf

swap_string "$HOME/parmanode/mempool/mempool-config.json" "CORE_RPC_USERNAME" \
"      CORE_RPC_USERNAME: \"$rpcuser\""

swap_string "$HOME/parmanode/mempool/mempool-config.json" "CORE_RPC_PASSWORD" \
"      CORE_RPC_PASSWORD: \"$rpcpassword\""

docker cp $HOME/parmanode/mempool/mempool-config.json docker-api-1:/backend/


docker compose restart api

log "mempool" "username password changed in mempool"

}