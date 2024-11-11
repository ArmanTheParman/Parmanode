function make_fulcrum_config {
# in parmanode variables ... export fc=$HOME/.fulcrum/fulcrum.conf
# docker run command ... -v $HOME/parmanode/fulcrum/config:/home/parman/parmanode/fulcrum/config \

source $bc >/dev/null 2>&1

#remove later, it's at the start of new_install_fulcrum
if [[ -z $rpcuser ]] ; then #from parmanode.conf 
    announce "Please set a username and password in Bitcoin conf. You can do that from the
    \r    Parmanode-Bitcoin menu. Aborting. " ; return 1 
fi

# set datadir variable
debug "fulcrumdocker: $fulcrumdocker
    drive_fulcrum: $drive_fulcrum
"
    if [[ $fulcrumdocker != "true" && $drive_fulcrum == "external" ]] ; then #works Linux and Mac
    datadir="$parmanode_drive/fulcrum_db" 
    fi

    if [[ $fulcrumdocker != "true" && $drive_fulcrum == "internal" ]] ; then
    datadir="$HOME/.fulcrum_db"
    fi

    if [[ $fulcrumdocker == "true" ]] ; then
    datadir="/home/parman/.fulcrum_db"
    cert="/home/parman/.fulcrum/cert.pem"
    key="/home/parman/.fulcrum/key.pem"
    else
    cert="$HOME/.fulcrum/cert.pem" 
    key="$HOME/.fulcrum/key.pem"
    fi

debug "datadir chosen, $datadir"

if [[ $computer_type == Pi ]] ; then fastsync=0 ; else fastsync=1000 ; fi

if [[ $fulcrumdocker == "true" ]] ; then local bitcoinIP="host.docker.internal" ; else local bitcoinIP="127.0.0.1" ; fi

#For fulcrumdkr, datadir is internal to the container. Then mounted in the run command. Then symlinks to external drive.
echo "fast-sync = $fastsync 
datadir = $datadir
bitcoind = $bitcoinIP:8332
ssl = 0.0.0.0:50002
tcp = 0.0.0.0:50001
cert = $cert
key = $key 
rpcuser = $rpcuser
rpcpassword = $rpcpassword
peering = false " | sudo tee -a $fc >$dn 2>&1

debug "after making the conf"

return 0
}