function  make_sparrow_config {
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
mkdir $HOME/.sparrow >/dev/null 2>&1
rm $HOME/.sparrow/config >/dev/null 2>&1
cp $original_dir/src/sparrow/config $HOME/.sparrow/config

swap_string "$HOME/.sparrow/config" "coreDataDir" "    \"coreDataDir\": \"$HOME/.bitcoin\","
swap_string "$HOME/.sparrow/config" "coreAuth\":" "    \"coreAuth\": \"$rpcuser:$rpcpassword\","


if [[ $1 == "fulcrumtor" ]] ; then
if ! which tor ; then install_tor ; fi
unset $ONION_ADDR_FULCRUM
get_onion_address_variable "fulcrum" >/dev/null

    if [[ -z $ONION_ADDR_FULCRUM ]] ; then
    set_terminal
    echo "Fulcrum Tor must first be enabled from the Fulcrum menu. Aborting."
    enter_continue
    make_sparrow_config
    return 1
    fi

swap_string "$HOME/.sparrow/config" "serverType" "    \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "useLegacyCoreWallet" "    \"useLegacyCoreWallet\": false,\n    \"electrumServer\": \"tcp://$ONION_ADDR_FULCRUM:7002\","
swap_string "$HOME/.sparrow/config" "useProxy" "    \"useProxy\": true,"
fi

if [[ $1 == "fulcrumssl" ]] ; then
swap_string "$HOME/.sparrow/config" "serverType" "    \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "useLegacyCoreWallet" "    \"useLegacyCoreWallet\": false,\n    \"electrumServer\": \"ssl://127.0.0.1:50002\","
swap_string "$HOME/.sparrow/config" "useProxy" "    \"useProxy\": true,"
fi

if [[ $1 == "fulcrumremote" ]] ; then
if ! which tor ; then install_tor ; fi
swap_string "$HOME/.sparrow/config" "serverType" "    \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "useLegacyCoreWallet" "    \"useLegacyCoreWallet\": false,\n    \"electrumServer\": \"tcp://$REMOTE_TOR_ADDR:$REMOTE_PORT\","
swap_string "$HOME/.sparrow/config" "useProxy" "    \"useProxy\": true,"
fi
}