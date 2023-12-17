function make_electrs_config {
local file="$HOME/.electrs/config.toml"

mkdir -p $HOME/.electrs >/dev/null 2>&1

if [[ $OS == Linux ]] ; then
    if [[ $drive_electrs == "external" ]] ; then 
        db_dir="/media/$USER/parmanode/electrs_db"
    else
        db_dir="$HOME/parmanode/electrs/electrs_db"
    fi
fi

if [[ $OS == Mac ]] ; then
    if [[ $drive_electrs == "external" ]] ; then 
        db_dir="/Volumes/parmanode/electrs_db"
    else
        db_dir="$HOME/parmanode/electrs/electrs_db"
    fi
fi

#This if block must come last
if [[ $install_electrs_docker == true && $drive_electrs == external ]] ; then
    export db_dir="/home/parman/electrs/electrs_db" #docker run command uses this path to volume mount.
fi

echo "daemon_rpc_addr = \"127.0.0.1:8332\"
daemon_p2p_addr = \"127.0.0.1:8333\"
db_dir = \"$db_dir\"
network = \"bitcoin\"
electrum_rpc_addr = \"127.0.0.1:50005\"
log_filters = \"INFO\" # Options are ERROR, WARN, INFO, DEBUG, TRACE
auth = \"$rpcuser:$rpcpassword\"
" | tee $file >/dev/null

}
