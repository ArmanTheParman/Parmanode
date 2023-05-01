# docker run -it --rm -v ~/.lnd:/root/.lnd -p 9735:9735 -p 10009:10009 \
#    --network host \
#    --bitcoin.active \
#    --bitcoin.node=bitcoind \
#    --bitcoin.regtest \
#    lnd