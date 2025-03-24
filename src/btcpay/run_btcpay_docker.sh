function run_btcpay_podman {
if [[ $OS == "Linux" ]] ; then
podman run -d -u parman \
           --name btcpay \
           --restart unless-stopped \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           --network="host" \
           btcpay >$dn
fi

if [[ $OS == "Mac" ]] ; then
podman run -d -u parman \
           --name btcpay \
           --restart unless-stopped \
           -v $HOME/.btcpayserver:/home/parman/.btcpayserver \
           -v $HOME/.nbxplorer:/home/parman/.nbxplorer \
           -v $HOME/.bitcoin:/home/parman/.bitcoin \
           -p 8333:8333 \
           -p 8332:8332 \
           -p 49393:49392 \
           -p 23001:23001 \
           btcpay >$dn
#           -p 24444:24444 \
#           -p 24445:24445 \

log "podman" "after podman run"
fi
}    

# Notes:
# 49392 is for REST API
   

