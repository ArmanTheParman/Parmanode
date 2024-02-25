function build_btcpay {

#get the USER ID, and match it to the parman ID inside the container.

thisID=$(id -u) 

docker build --build-arg parmanID=$thisID -t btcpay $original_dir/src/btcpay && \
    log "btcpay" "build success" && return 0 || log "btcpay" "build failure" && enter_continue \
    return 1
}
