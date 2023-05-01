function run_btcpay_docker {

docker run -d \
           --name btcpay \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           --network="host" \
           btcpay && \
log "btcpay" "docker run btcpay executed" && return 0 \
|| log "btcpay" "docker run btcpay failed" && return 1

}    

    # Notes:
    # take note of the host bitcoin rpcport.
    # make sure the 8080 port is not duplicated when other programs, eg RTL, are added.
    # 49392 is for REST API
    # 9735 is not needed by BTCpay; LND uses that for LN protocol communication
    # 8070, 8060 and 8050 are spare ports so users wont have to re-run (remake) the container for
    # extra features later.

