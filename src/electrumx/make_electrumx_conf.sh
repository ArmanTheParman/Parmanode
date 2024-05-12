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

" | tee $hp/electrumx/electrumx.conf >/dev/null 2>&1
}

# LOG_LEVEL can be - 'debug', 'info', 'warning' and 'error'.

#.. envvar:: DB_ENGINE
#
#  Database engine for the UTXO and history database.  The default is
#  ``leveldb``.  The other alternative is ``rocksdb``.  You will need
#  to install the appropriate python package for your engine.  The
#  value is not case sensitive.
#
# FORCE_PROXY
#  By default peer discovery happens over the clear internet.  Set this
#  to non-empty to force peer discovery to be done via the proxy.  This
#  might be useful if you are running a Tor service exclusively and
#  wish to keep your IP address private.
#
#
#
#
#
# envvar:: REPORT_SERVICES
#
#  A comma-separated list of services ElectrumX will advertize and other servers in the
#  server network (if peer discovery is enabled), and any successful connection.
#
#  This environment variable must be set correctly, taking account of your network,
#  firewall and router setup, for clients and other servers to see how to connect to your
#  server.  If not set or empty, no services are advertized.
#
#  The **rpc** protocol, special IP addresses (including private ones if peer discovery is
#  enabled), and :const:`localhost` are invalid in :envvar:`REPORT_SERVICES`.
#
#  Here is an example value of the :envvar:`REPORT_SERVICES` environment variable::
#
#    tcp://sv.usebsv.com:50001,ssl://sv.usebsv.com:50002,wss://sv.usebsv.com:50004
#
#  This advertizes **tcp**, **ssl**, **wss** services at :const:`sv.usebsv.com` on ports
#  50001, 50002 and 50004 respectively.
