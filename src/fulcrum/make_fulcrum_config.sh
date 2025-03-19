function make_fulcrum_config {
# in parmanode variables ... export fc=$HOME/.fulcrum/fulcrum.conf
# docker run command ... -v $HOME/parmanode/fulcrum/config:/home/parman/parmanode/fulcrum/config \

[[ -z $coinfgure_bitcoin_self ]] && source $bc >$dn 2>&1

# set datadir variable

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

if [[ $computer_type == Pi ]] ; then fastsync=0 ; else fastsync=1000 ; fi

if [[ $fulcrumdocker == "true" && $OS == Mac ]] ; then local bitcoinIP="host.docker.internal" ; else local bitcoinIP="127.0.0.1" ; fi

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

return 0
}