function grpccurl_call {
    
    grpcurl -plaintext \
    -import-path $hp/lnd/lnrpc/ \
    -proto lightning.proto \
    -d '{}' \
    -rpc-header "macaroon: $(xxd -ps -u -c 1000 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon)" \
    localhost:10009 lnrpc.Lightning/GetInfo
}