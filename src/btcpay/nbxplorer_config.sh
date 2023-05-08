function nbxplorer_config {
    source <(cat $HOME/.bitcoin/bitcoin.conf | grep "rpcuser=")
    source <(cat $HOME/.bitcoin/bitcoin.conf | grep "rpcpassword=")

echo "
btc.rpc.user=${rpcuser}
btc.rpc.pass=${rpcpassword}
btc.rpc.url=http://192.168.0.166:8332
bind=0.0.0.0:24445
port=24445
mainnet=1
postgres=User ID=parman;Password=NietShitcoin;Host=localhost;Port=5432;Database=nbxplorer;
" | tee $HOME/.nbxplorer/Main/settings.config >/dev/null 2>&1 || \
    { log "nbxplorer" "failed to make settings.config" && \
    log "nbxplorer" "failed to make settings.config" && errormessage && return 1 ; }

log "nbxplorer" "end nbxplorer_config" && return 0
}
