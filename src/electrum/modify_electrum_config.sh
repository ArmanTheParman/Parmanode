function modify_electrum_config {
set_terminal
enter_continue "Reminder: Make sure Electrum has been shut down before proceeding."

if [[ $1 == fulcrumssl ]] ; then
server="127.0.0.1:50002:s"
x=FulcrumSSL # fixing capitalisation for later variable usage
fi

if [[ $1 == fulcrumtcp ]] ; then
debug "fulcrumtcp"
server="127.0.0.1:50001:t"
x=FulcrumTCP
fi

if [[ $1 == electrstcp || -z $1 ]] ; then
debug "electrstcp"
server="127.0.0.1:50005:t"
x=electrsTCP
fi

if [[ $1 == electrsssl ]] ; then
debug "electrsssl"
server="127.0.0.1:50006:s"
x=electrsSSL
fi

if [[ $1 == electrumxtcp || -z $1 ]] ; then
server="127.0.0.1:50007:t"
x=electrumxTCP
fi

if [[ $1 == electrumxssl ]] ; then
debug "electrumxssl"
server="127.0.0.1:50008:s"
x=electrumxSSL
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
}" | tee $HOME/.electrum/config >$dn 2>&1
debug "after tee"

echo "connection=\"$x\"" > $HOME/.parmanode/electrum.connection
debug "after electrum.connection file"

}
