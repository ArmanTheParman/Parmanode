function run_btcpay_docker {

docker run -d \
           --name btcpay \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           -p 8080:8080 \
           -p 23001:23001 \
           -p 49392:49392 \
           -p 5432:5432 \
           -p 9735:9735 \
           -p 8332:8332 \
           btcpay && \
log "btcpay" "docker run btcpay executed" && return 0 \
|| log "btcpay" "docker run btcpay failed" && return 1 

}    

    # Notes:
    # make sure the 8080 port is not duplicated when other programs, eg RTL, are added.
    # 49392 is for REST API
    # 9735 is not needed by BTCpay; LND uses that for LN protocol communication
    # 8332 on the host is in use by Fulcrum. New port to listen will be 8335. 
              #"port switch" at container interface.
              #add rpcport=8335 to bitcoin conf
