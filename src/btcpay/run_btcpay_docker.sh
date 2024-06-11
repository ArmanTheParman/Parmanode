function run_btcpay_docker {
if [[ $OS == "Linux" ]] ; then
docker run -d -u parman \
           --name btcpay \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           --network="host" \
           btcpay >/dev/null
fi

if [[ $OS == "Mac" ]] ; then
docker run -d -u parman \
           --name btcpay \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           -v $HOME/.bitcoin:/home/parman/.bitcoin \
           -p 49393:49392 \
           -p 23001:23001 \
           -p 24444:24444 \
           -p 24445:24445 \
           btcpay >/dev/null

log "docker" "after docker run"
fi
}    

    # Notes:
    # take note of the host bitcoin rpcport.
    # make sure the 8080 port is not duplicated when other programs, eg RTL, are added.
    # 49392 is for REST API
    # 9735 is not needed by BTCpay; LND uses that for LN protocol communication
   

