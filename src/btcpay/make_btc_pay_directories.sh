function make_btcpay_directories {
#delete existing; check with user.
mkdir -p ~/.btcpayserver/Main ~/.nbxplorer/Main && \
  log "btcpay" ".btcpayserver mkdir success" && return 0 \
  || return 1 && log "btcpay" "mkdir .bitpayserver & .nbxploerer failed"
}