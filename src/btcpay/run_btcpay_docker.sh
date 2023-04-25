function run_btcpay_docker {

docker run -d \
           --name btcpay \ 
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           -p 8080:8080 \
           -p 23001:80 \
           -p 49392:49392i \
           btcpay && \
log "btcpay" "docker run btcpay executed" \
|| log "btcpay" "docker run btcpay failed" && return 1 

return 0
}    

    # Notes:
    # make sure the 8080 port is not duplicated when other programs, eg RTL, are added.
    # 49392 is for REST API
    # 9735 is not needed by BTCpay; LND uses that for LN protocol communication
