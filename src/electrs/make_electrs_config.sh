function make_electrs_config {
local file="$HOME/.electrs/config.toml"

mkdir -p $HOME/.electrs >$dn 2>&1

if [[ $install_electrs_docker_variable == "false" ]] ; then

    if [[ $drive_electrs == "external" ]] 
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
electrum_rpc_addr = \"0.0.0.0:50005\"
log_filters = \"INFO\" # Options are ERROR, WARN, INFO, DEBUG, TRACE
                       # Changing this will affect parmanode menu output negatively
auth = \"$rpcuser:$rpcpassword\"
" | tee $file >$dn

if [[ $install_electrs_docker_variable == "true" && $OS == Mac ]] ; then #mac has funny networking.
gsed -i "/daemon_rpc_addr/c\daemon_rpc_addr = \"host.docker.internal:8332\"" $file  >$dn 2>&1 #necessary to reach bitcoin on the host
gsed -i "/daemon_p2p_addr/c\daemon_p2p_addr = \"host.docker.internal:8333\"" $file  >$dn 2>&1
fi
}
