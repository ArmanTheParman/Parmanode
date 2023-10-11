function make_electrs_config {
mkdir -p $HOME/.electrs

if [[ $drive_electrs == "external" ]] ; then 
    db_dir="/media/$USER/parmanode/electrs_db"
else
    db_dir="$HOME/parmanode/electrs/electrs_db"
fi

echo "daemon_rpc_addr = \"127.0.0.1:8332\"
daemon_p2p_addr = \"127.0.0.1:8333\"
db_dir = \"$db_dir\"
network = \"bitcoin\"
electrum_rpc_addr = \"127.0.0.1:50005\"
log_filters = \"INFO\"
auth = \"$rpcuser:$rpcpassword\"
" | tee $HOME/.electrs/config.toml >/dev/null

}
