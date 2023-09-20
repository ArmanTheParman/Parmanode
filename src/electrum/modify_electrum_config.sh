function modify_electrum_config {
set_terminal
echo "Make sure Electrum has been shut down before proceeding."
enter_continue

refresh_electrum_certs_cache_sockets

if [[ $1 == fulcrumssl || -z $1 ]] ; then
server="127.0.0.1:50002:s"
x=FulcrumSSL # fixing capitalisation for later variable usage
fi

if [[ $1 == fulcrumtcp ]] ; then
server="127.0.0.1:50001:t"
x=FulcrumTCP
fi

if [[ $1 == electrstcp ]] ; then
server="127.0.0.1:50005:t"
x=electrsTCP
fi

if [[ $1 == electrsssl ]] ; then
server="127.0.0.1:50006:s"
x=electrsSSL
fi

echo "{
    \"auto_connect\": false,
    \"check_updates\": false,
    \"config_version\": 3,
    \"decimal_point\": 8,
    \"is_maximized\": false,
    \"oneserver\": true,
    \"server\": \"$server\",
    \"show_addresses_tab\": true,
    \"show_utxo_tab\": true
}" | tee $HOME/.electrum/config >/dev/null 2>&1

echo "connection=\"$x\"" > $HOME/.parmanode/electrum.connection

}
