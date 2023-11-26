function add_server_1_to_bitcoinconf {
if grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
if ! cat $HOME/.bitcoin/bitcoin.conf | grep "server=1" >/dev/null 2>&1 ; then
    set_terminal
echo -e "
########################################################################################
    
    Bitcoin needs to be restarted to add the line$cyan \"server=1\"$orange to the config file.

    Hit$red s$orange to skip or$green anything else$cyan to continue and allow the changes to be made.

########################################################################################
"
read choice
if [[ $choice == "s" ]] ; then return ; fi

    stop_bitcoind
    echo "server=1" | tee -a $bc >/dev/null 2>&1
    run_bitcoind
fi
fi
}