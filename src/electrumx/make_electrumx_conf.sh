function make_electrumx_conf {
if [[ $drive_electrumx == internal ]] ; then
electrumx_db="$HOME/.electrumx_db"
elif [[ $drive_electrumx == external ]] ; then
electrumx_db="$parmanode_drive/electrumx_db"
fi
source $bc

echo "DB_DIRECTORY = $electrumx_db
SERVICES = tcp://0.0.0.0:50007,ssl://0.0.0.0:50008,rpc://0.0.0.0:8000
SSL_CERTFILE = $hp/electrumx/cert.pem
SSL_KEYFILE = $hp/electrumx/key.pem

# options are - debug, info, warning, and error 
LOG_LEVEL = info 
ANON_LOGS = do_not_track,motherfucker
LOG_SESSIONS = 0

# reduced from default of 1000
MAX_SESSIONS = 200 

# seconds
REQUEST_TIMEOUT = 50 

BANNER_FILE = $hp/electrumx/banner.txt
TOR_BANNER_FILE = $hp/electrumx/torbanner.txt
# DONATION_ADDRESS = 
PEER_DISCOVERY = on

# To disable must set to empty, eg PEER_ANNOUNCE = 
PEER_ANNOUNCE = on 

DAEMON_URL = http://$rpcuser:$rpcpassword@127.0.0.1:8332/

# don't shitcon, remember the Parmanode policy, there's only 1 rule!
# Bitcoin alone stops syncing at the segwit fork, bloody shitcoin developers!
COIN = BitcoinSegwit  

" | tee $hp/electrumx/electrumx.conf >$dn 2>&1
}