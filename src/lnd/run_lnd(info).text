 docker run -it -v ~/.lnd:/root/.lnd -p 9735:9735 -p 10009:10009 \
    lnd \
    /bin/bash -c "/bin/lnd \
    --network host \
    --bitcoin.active \
    --bitcoin.node=bitcoind"

# --rm option removed (removes container when stopped)
#docker run -d --name lnd -v $HOME/.lnd-dat:/lnd -v $HOME/.lnd:/root/.lnd -p 9735:9735 -p 10009:10009 lnd
exec lnd \
    --noseedbackup \
    "--$CHAIN.active" \
    "--$CHAIN.$NETWORK" \
    "--$CHAIN.node"="$BACKEND" \
    "--$BACKEND.rpccert"="/rpc/rpc.cert" \
    "--$BACKEND.rpchost"="blockchain" \
    "--$BACKEND.rpcuser"="$RPCUSER" \
    "--$BACKEND.rpcpass"="$RPCPASS" \
    "--rpclisten=$HOSTNAME:10009" \
    "--rpclisten=localhost:10009" \
    --debuglevel="$DEBUG" \
    "$@"