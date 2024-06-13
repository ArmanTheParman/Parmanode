function nbxplorer_config {

source $bc >/dev/null

if [[ $btcpayinstallsbitcoin == "true" ]] || [[ $OS == Mac ]] ; then 
local rpcuser=parman  
local rpcpassword=parman 
local localhost=127.0.0.1
else
local localhost="localhost"
fi

echo "
btc.rpc.user=${rpcuser}
btc.rpc.password=${rpcpassword}
port=24445
mainnet=1
postgres=User ID=parman;Password=NietShitcoin;Host=$localhost;Port=5432;Database=nbxplorer;
" | tee $HOME/.nbxplorer/Main/settings.config >/dev/null 2>&1 

}
#Changed from localhost to 127.0.0.1
#postgres=User ID=parman;Password=NietShitcoin;Host=localhost;Port=5432;Database=nbxplorer;