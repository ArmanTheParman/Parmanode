function run_btcpay_docker {
if [[ $OS == "Linux" ]] ; then
docker run -d -u parman \
           --name btcpay \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           --network="host" \
           btcpay 
fi

if [[ $OS == "Mac" ]] ; then
docker run -d -u parman \
           --name btcpay \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           -p 49393:49392 \
           -p 23001:23001 \
           -p 24445:24445 \
           -p 8332:8332 \
           -p 8070:8070 \
           -p 8080:8080 \
           -p 8090:8090 \
           btcpay 

debug1 "after docker run"
log "docker" "after docker run"
fi
}    

    # Notes:
    # take note of the host bitcoin rpcport.
    # make sure the 8080 port is not duplicated when other programs, eg RTL, are added.
    # 49392 is for REST API
    # 9735 is not needed by BTCpay; LND uses that for LN protocol communication
   

