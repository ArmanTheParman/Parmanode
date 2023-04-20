function make_fulcrum_config {
source $HOME/.parmanode/parmanode.conf

# make config file
if [[ -z $rpcuser ]] ; then #from parmanode.conf 
    set_rpc_authentication 
    if [ $? != 0 ] ; then set_terminal ; echo "Error setting rps user/pass. Aborting installation." ; enter_continue ; return 1 ; fi
fi

# set datadir variable

    if [[ $drive_fulcrum == "external" && $OS == "Linux" ]] ; then
    datadir="/media/$(whoami)/parmanode/fulcrum_db" ; fi

    if [[ $drive_fulcrum == "external" && $OS == "Mac" ]] ; then
    datadir="/Volumes/parmanode/fulcrum_db" ; fi

    if [[ $drive_fulcrum == "internal" ]] ; then
    datadir="/$HOME/parmanode/fulcrum_db"
    fi

# make config file
echo "
datadir = $datadir
bitcoind = 127.0.0.1:8332
ssl = 0.0.0.0:50002
cert = $HOME/parmanode/fulcrum/cert.pem
key = $HOME/parmanode/fulcrum/key.pem
peering = false " > $HOME/parmanode/fulcrum/fulcrum.conf || \
{ log "fulcrum" "make_fulcrum_config, echo redirect failed." ; \
debug "echo redirect failed when making fulcrum.conf" ; return 1 ;}

edit_user_pass_fulcrum_conf #gets user and pass from bitcoin.conf and adds to fulcrum.conf

log "fulcrum" "fulcrum config file made"
return 0
}