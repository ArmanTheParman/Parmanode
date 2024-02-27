function make_public_pool_env {
source $bc

if [[ $OS == Mac ]] ; then 
IPurl="host.docker.internal"
else
IPurl=$IP
fi

cat << EOF | tee $hp/public_pool/.env >/dev/null
BITCOIN_RPC_URL=http://$IPurl
BITCOIN_RPC_USER=$rpcuser
BITCOIN_RPC_PASSWORD=$rpcpassword
BITCOIN_RPC_PORT=8332
BITCOIN_RPC_TIMEOUT=10000
BITCOIN_ZMQ_HOST="tcp://$IPurl:28332"
API_PORT=3334
STRATUM_PORT=3333
DEV_FEE_ADDRESS=
NETWORK=mainnet
API_SECURE=false
ENABLE_SOLO=false
ENABLE_PROXY=true
BRAIINS_ACCESS_TOKEN=
PROXY_PORT=3333
EOF
}