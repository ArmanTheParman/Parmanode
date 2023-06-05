function make_electrum_config {
if [[ $OS == "Linux" ]] ; then
echo "{
    \"auto_connect\": false,
    \"check_updates\": false,
    \"config_version\": 3,
    \"decimal_point\": 8,
    \"is_maximized\": false,
    \"oneserver\": true,
    \"server\": \"localhost:50002:s\",
    \"show_addresses_tab\": true,
    \"show_utxo_tab\": true
}" | tee $HOME/.electrum/config >/dev/null 2>&1
fi

if [[ $OS == "Mac" ]] ; then 
echo "{
    \"auto_connect\": false,
    \"check_updates\": false,
    \"config_version\": 3,
    \"decimal_point\": 8,
    \"is_maximized\": false,
    \"oneserver\": true,
    \"server\": \"172.17.0.2:50002:s\",
    \"show_addresses_tab\": true,
    \"show_utxo_tab\": true
}" | tee $HOME/.electrum/config >/dev/null 2>&1
fi


}