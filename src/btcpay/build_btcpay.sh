function build_btcpay {

docker build -t btcpay ./src/btcpay && \
    log "btcpay" "build succes" && return 0 || log "btcpay" "build failure" && \
    return 1
}