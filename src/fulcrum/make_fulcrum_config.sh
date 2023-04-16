function make_fulcrum_config {
source $HOME/.parmanode/parmanode.conf

# set datadir variable

    if [[ $drive_fulcrum == "external" && $OS == "Linux" ]] ; then
    datadir="/media/$(whoami)/parmanode/fulcrum_db" ; fi

    if [[ $drive_fulcrum == "external" && $OS == "Mac" ]] ; then
    datadir="/Volumes/parmanode/fulcrum_db" ; fi

    if [[ $drive_fulcrum == "internal" ]] ; then
    datadir="/$HOME/parmanode/fulcrum_db"

# make config file, part 1
echo "
datadir = $datadir
bitcoind = 127.0.0.1:8332
ssl = 0.0.0.0:50002
cert = $HOME/parmanode/fulcrum/cert.pem
key = $HOME/parmanode/fulcrum/key.pem
peering = false " > $HOME/parmanode/fulcrum/fulcrum.conf || \
{ log "fulcrum" "make_fulcrum_config, echo redirect failed." ; \
debug "echo redirect failed when making fulcrum.conf" ; return 1 ;}

# make config file, part 2
if [[ -z $rpcuser ]] ; then ; return 0
else
echo "rpcuser = $rpcuser
rpcpassword = $rpcpassword" > $HOME/parmanode/fulcrum/fulcrum.conf || \
{ log "fulcrum" "make_fulcrum_config, echo redirect failed." ; \
debug "echo redirect failed when making fulcrum.conf" ; return 1 ; }
fi

return 0
}