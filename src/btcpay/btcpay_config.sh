function btcpay_config {

echo "
network=mainnet
port=23001
bind=0.0.0.0
chains=btc
postgres=User ID=postgres;Host=127.0.0.1;Port=5432;Database=btcpayserver;
" | tee $HOME/.btcpayserver/Main/settings.config >/dev/null 2>&1 || \
    { log "btcpay" "failed to make settings.config" && \
    log "btcpay" "failed to make settings.config" && errormessage && return 1 ; }

log "btcpay" "End btcpayserver_config" && return 0
}
#postgres=User ID=parman;Password=NietShitcoin;Host=172.17.0.1;Port=5432;Database=btcpayserver;