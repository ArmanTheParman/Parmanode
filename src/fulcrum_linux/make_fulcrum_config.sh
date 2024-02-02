function make_fulcrum_config {
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1

# make config file
if which bitcoind >/dev/null 2>&1 ; then
    if [[ -z $rpcuser ]] ; then #from parmanode.conf 
        announce "In the next screen, you need to select a username/password for Bitcoin
        connections, otherwise Fulcrum won't autoconnect with Parmanode."
        set_rpc_authentication || { announce "Error setting rps user/pass. Aborting Fulcrum installation." ; return 1 ; }
        set_terminal
    fi
fi

# set datadir variable

    if [[ $drive_fulcrum == "external" ]] ; then #works Linux and Mac
    datadir="$drive/parmanode/fulcrum_db" 
    fi

    if [[ $drive_fulcrum == "internal" ]] ; then
    datadir="$HOME/parmanode/fulcrum_db"
    fi

# make config file
source $dp/parmanode.conf >/dev/null
if [[ $computer_type == Pi ]] ; then fastsync=0 ; else fastsync=1000 ; fi
echo "
fast-sync = $fastsync 
datadir = $datadir
bitcoind = 127.0.0.1:8332
ssl = 0.0.0.0:50002
tcp = 0.0.0.0:50001
cert = $HOME/parmanode/fulcrum/cert.pem
key = $HOME/parmanode/fulcrum/key.pem
peering = false " > $HOME/parmanode/fulcrum/fulcrum.conf || \
{ log "fulcrum" "make_fulcrum_config, echo redirect failed." ; \
debug "echo redirect failed when making fulcrum.conf" ; return 1 ;}

if which bitcoind >/dev/null 2>&1 ; then
edit_user_pass_fulcrum_conf #gets user and pass from bitcoin.conf and adds to fulcrum.conf
fi

log "fulcrum" "fulcrum config file made"
return 0
}