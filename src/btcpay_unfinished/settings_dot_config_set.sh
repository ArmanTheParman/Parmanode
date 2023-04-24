function settings_dot_config_set {
########################################################################################

# Make a config file with docker exec command, details below.


#RUN touch ~/.nbxplorer/Main/settings.config
#
#btc.rpc.auth=<bitcoind rpc user>:<bitcoind rpc password>
#port=24445
#mainnet=1
#postgres=User ID=<your db user>;Password=<your db password>;Host=localhost;Port=5432;Database=nbxplorer;
#
#Make sure to use your bitcoind's rpc login credentials. You can find them with the command:
}


#add these:

network=mainnet
port=23001
bind=0.0.0.0
chains=btc
BTC.explorer.url=http://127.0.0.1:24445
BTC.lightning=type=lnd-rest;server=https://127.0.0.1:8080/;macaroonfilepath=~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon;certthumbprint=<fingerprint>
postgres=User ID=<your db user>;Password=<your db password>;Host=localhost;Port=5432;Database=btcpayserver;


make sure all ports are right (23001, 5432)
should database= btcpayserver or nbxporer?