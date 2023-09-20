# Earlier versions of parmanode didn't have this line in bitcoin conf, so just 
# making sure it's in there. If not, it skips.

function add_localhost_to_bitcoinconf {
if grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
if ! cat $HOME/.bitcoin/bitcoin.conf | grep "rpcallowip=127.0.0.1" >/dev/null 2>&1 ; then
    set_terminal
    echo ' 
    Bitcoin needs to be restarted to add the line "rpcallowip=127.0.0.1" 
    to the config file.'
    echo ""
    echo "Hit s to skip or anything else to continue."
    read choice

    if [[ $choice == "s" ]] ; then return 
    fi

    stop_bitcoind
    echo "rpcallowip=127.0.0.1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    debug "check rpc line added"
    run_bitcoind
fi
fi

}