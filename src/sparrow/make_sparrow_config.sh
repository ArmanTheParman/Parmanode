# takes arguments to set connection type
# defualt, no argument, is plain connection to Bitcoin Core.
function  make_sparrow_config {
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
if [[ ! -e $HOME/.sparrow ]] ; then mkdir $HOME/.sparrow >/dev/null 2>&1 ; fi
rm $HOME/.sparrow/config >/dev/null 2>&1
cp $original_dir/src/sparrow/config $HOME/.sparrow/config # copies template across

# These settings can be written every time regardless of connection type...
swap_string "$HOME/.sparrow/config" "coreDataDir" "  \"coreDataDir\": \"$HOME/.bitcoin\","
swap_string "$HOME/.sparrow/config" "coreAuth\":" "  \"coreAuth\": \"$rpcuser:$rpcpassword\","
# serverType is BITCOIN_CORE on the template
# coreAuthType is USERPASS on the template

echo "connection=Bitcoin_userpass" > $HOME/.parmanode/sparrow.connection

    #cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

    if [[ $1 == "cookie" ]] ; then 
    swap_string "$HOME/.sparrow/config" "coreAuthType" "  \"coreAuthType\": \"COOKIE\","
    echo "connection=Bitcoin_cookie" > $HOME/.parmanode/sparrow.connection #overwrites previous, so order important.
    return 0
    fi

    if [ -z $1 ] ; then return 0 ; fi # not more if checks as argument is empty.
    #cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [[ $1 == "fulcrumtor" ]] ; then
if ! which tor >/dev/null 2>&1 ; then install_tor ; fi
unset $ONION_ADDR_FULCRUM
get_onion_address_variable "fulcrum" >/dev/null

    if [[ -z $ONION_ADDR_FULCRUM ]] ; then
    set_terminal
    echo "Fulcrum Tor must first be enabled from the Fulcrum menu. Aborting."
    enter_continue
    make_sparrow_config
    return 1
    fi
swap_string "$HOME/.sparrow/config" "serverType" "  \"serverType\": \"ELECTRUM_SERVER\"," 

swap_string "$HOME/.sparrow/config" "electrumServer" "  \"electrumServer\": \"tcp://$ONION_ADDR_FULCRUM:7002\","
swap_string "$HOME/.sparrow/config" "useProxy" "   \"useProxy\": true,"
echo "connection=FulcrumTOR" > $HOME/.parmanode/sparrow.connection
fi
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if [[ $1 == "fulcrumssl" ]] ; then
swap_string "$HOME/.sparrow/config" "serverType" "   \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "electrumServer" "  \"electrumServer\": \"ssl://127.0.0.1:50002\","
swap_string "$HOME/.sparrow/config" "useProxy" "   \"useProxy\": false,"
echo "connection=FulcrumSSL" > $HOME/.parmanode/sparrow.connection
return 0
fi

if [[ $1 == "fulcrumtcp" ]] ; then
swap_string "$HOME/.sparrow/config" "serverType" "  \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "electrumServer" "   \"electrumServer\": \"tcp://127.0.0.1:50001\","
swap_string "$HOME/.sparrow/config" "useProxy" "  \"useProxy\": false,"
echo "connection=FulcrumTCP" > $HOME/.parmanode/sparrow.connection
return 0
fi

if [[ $1 == "fulcrumremote" ]] ; then
if ! which tor ; then install_tor ; fi
swap_string "$HOME/.sparrow/config" "serverType" "    \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "electrumServer" "  \"electrumServer\": \"tcp://$REMOTE_TOR_ADDR:$REMOTE_PORT\","
swap_string "$HOME/.sparrow/config" "useProxy" "   \"useProxy\": true,"
echo "connection=FulcrumRemoteTOR" > $HOME/.parmanode/sparrow.connection
return 0
fi

if [[ $1 == "electrstcp" ]] ; then
swap_string "$HOME/.sparrow/config" "serverType" "  \"serverType\": \"ELECTRUM_SERVER\"," 
swap_string "$HOME/.sparrow/config" "electrumServer" "  \"electrumServer\": \"tcp://127.0.0.1:50005\","
swap_string "$HOME/.sparrow/config" "useProxy" "  \"useProxy\": false,"
echo "connection=electrsTCP" > $HOME/.parmanode/sparrow.connection
return 0
fi

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
if [[ $1 == "electrstor" ]] ; then
if ! which tor >/dev/null 2>&1 ; then install_tor ; fi
unset $ONION_ADDR_ELECTRS
get_onion_address_variable "electrs" >/dev/null

    if [[ -z $ONION_ADDR_ELECTRS ]] ; then
    set_terminal
    echo "Electrs Tor must first be enabled from the electrs menu. Aborting."
    enter_continue
    make_sparrow_config
    return 1
    fi
swap_string "$HOME/.sparrow/config" "serverType" "   \"serverType\": \"ELECTRUM_SERVER\"," 

swap_string "$HOME/.sparrow/config" "electrumServer" "  \"electrumServer\": \"tcp://$ONION_ADDR_ELECTRS:7004\","
swap_string "$HOME/.sparrow/config" "useProxy" "   \"useProxy\": true,"
echo "connection=ElectrsTOR" > $HOME/.parmanode/sparrow.connection
fi
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
}