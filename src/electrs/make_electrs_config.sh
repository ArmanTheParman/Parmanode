function make_electrs_config {
local file="$HOME/.electrs/config.toml"

mkdir -p $HOME/.electrs >/dev/null 2>&1

if [[ $install_electrs_docker == false ]] ; then

    if [[ $drive_electrs == external ]] 
    then
       db_dir="$parmanode_drive/electrs_db"
    else
       db_dir="$HOME/.electrs_db"
    fi

else
       db_dir="/electrs_db" #docker run command uses this path to volume mount.
fi

echo "daemon_rpc_addr = \"127.0.0.1:8332\"
daemon_p2p_addr = \"127.0.0.1:8333\"
db_dir = \"$db_dir\"
network = \"bitcoin\"
electrum_rpc_addr = \"127.0.0.1:50005\"
log_filters = \"INFO\" # Options are ERROR, WARN, INFO, DEBUG, TRACE
                       # Changing this will affect parmanode menu output negatively
auth = \"$rpcuser:$rpcpassword\"
" | tee $file >/dev/null

if [[ $install_electrs_docker == true && $OS == Mac ]] ; then #mac has funny networking.
swap_string "$file" "daemon_rpc_addr" "daemon_rpc_addr = \"host.docker.internal:8332\"" #necessary to reach bitcoin on the host
swap_string "$file" "daemon_p2p_addr" "daemon_p2p_addr = \"host.docker.internal:8333\""
fi
}
