function build_btcpay {

docker build -t btcpay $original_dir/src/btcpay && \
    log "btcpay" "build success" && return 0 || log "btcpay" "build failure" && enter_continue \
    return 1
}
