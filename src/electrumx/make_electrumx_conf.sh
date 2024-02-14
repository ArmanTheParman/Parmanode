function make_electrumx_conf {
if [[ $drive_electrumx == internal ]] ; then
electrumx_db="$HOME/.electrumx_db"
elif [[ $drive_electrumx == external ]] ; then
electrumx_db="$parmanode_drive/electrumx_db"
fi
source $bc

echo "DB_DIRECTORY = $electrumx_db
DAEMON_URL = http://$rpcuser:$rpcpassword@127.0.0.1:8332/
COIN = Bitcoin" | tee $hp/electrumx/electrumx.conf >/dev/null 2>&1
}