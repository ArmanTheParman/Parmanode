function make_electrum_config {
echo "{
    \"auto_connect\": false,
    \"check_updates\": false,
    \"config_version\": 3,
    \"decimal_point\": 8,
    \"is_maximized\": false,
    \"oneserver\": true,
    \"server\": \"127.0.0.1:50002:s\",
    \"show_addresses_tab\": true,
    \"show_utxo_tab\": true
}" | tee $HOME/.electrum/config >$dn 2>&1
    
echo "connection=\"FulcrumSSL\"" > $HOME/.parmanode/electrum.connection
}
