function build_btcpay {

docker build -t btcpay $original_dir/src/btcpay && \
    log "btcpay" "build succes" && return 0 || log "btcpay" "build failure" && enter_continue \
    return 1
}