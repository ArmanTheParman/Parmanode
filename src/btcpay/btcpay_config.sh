function btcpay_config {

echo "
network=mainnet
port=23001
bind=0.0.0.0
chains=btc
BTC.explorer.url=http://127.0.0.1:24445
postgres=User ID=parman;Password=NietShitcoin;Host=localhost;Port=5432;Database=btcpayserver;
" | tee $HOME/.btcpayserver/Main/settings.config || \
    { log "btcpayserver" "failed to make settings.config" && \
    log "btcpayserver" "failed to make settings.config" && errormessage && return 1 ; }

log "btcpayserver" "End btcpayserver_config" && return 0
}