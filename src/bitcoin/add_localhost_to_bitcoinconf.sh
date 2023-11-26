# Earlier versions of parmanode didn't have this line in bitcoin conf, so just 
# making sure it's in there. If not, it skips.

function add_localhost_to_bitcoinconf {
if grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
if ! cat $HOME/.bitcoin/bitcoin.conf | grep "rpcallowip=127.0.0.1" >/dev/null 2>&1 ; then
    set_terminal
echo -e "
########################################################################################
    
    Bitcoin needs to be restarted to add the line$cyan \"rpcallowip=127.0.0.1\"$orange to 
    
    the config file. 
    
    Hit$red s$orange to skip or$green anything else$cyan to continue and allow the changes to be made.

########################################################################################
"
    read choice

    if [[ $choice == "s" ]] ; then return ; fi

    stop_bitcoind
    echo "rpcallowip=127.0.0.1" | tee -a $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
    run_bitcoind
fi
fi
}

