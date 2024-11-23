function btcpay_config {

echo -e "
network=mainnet
bind=0.0.0.0
port=23001
chains=btc
BTC.explorer.url=http://127.0.0.1:24445
postgres=User ID=parman;Password=NietShitcoin;Host=localhost;Port=5432;Database=btcpayserver;
" | tee $HOME/.btcpayserver/Main/settings.config >$dn 2>&1 
}

#bind=0.0.0.0 is necessary for the btcpayserver page to load using other computers.
#it was previously ommitted, binding it to loopback address.