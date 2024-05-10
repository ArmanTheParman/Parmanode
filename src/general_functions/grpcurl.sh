function grpccurl_call {

if ! which grpcurl >/dev/null ; then

    if [[ $OS == Mac ]] ; then 
        set_terminal 
        echo -e "${green}Installing grpcurl...$orange"
        brew install grpccurl 
    else
        set_terminal 
        echo -e "${green}Installing grpcurl...$orange"
        go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
    fi
fi

    grpcurl -plaintext \
    -import-path $hp/lnd/lnrpc/ \
    -proto lightning.proto \
    -d '{}' \
    -rpc-header "macaroon: $(xxd -ps -u -c 1000 $HOME/.lnd/data/chain/bitcoin/mainnet/admin.macaroon)" \
    localhost:10009 lnrpc.Lightning/GetInfo
}