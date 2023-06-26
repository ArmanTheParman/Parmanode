function  make_sparrow_config {
source $HOME/.bitcoin/bitcoin.conf >/dev/null 2>&1
mkdir $HOME/.sparrow >/dev/null 2>&1
cp $original_dir/src/sparrow/config $HOME/.sparrow/config
swap_string "$HOME/.sparrow/config" "coreDataDir" "\"coreDataDir\": \"    $HOME/.bitcoin\","
swap_string "$HOME/.sparrow/config" "coreAuth\":" "\"coreAuth\": \"    $rpcuser:$rpcpassword\","
}




#work in progress...
function temp {
return 0

if [[ $1 == "fulcrum-tor" ]] ; then

get_onion_address_variable "fulcrum"


swap_string "$HOME/.sparrow/config" "serverType" "\"serverType\": \"ELECTRUM_SERVER\"," 

swap_string "$HOME/.sparrow/config" "coreServer" "\"coreServer\": \"http:$ONION_ADDR\"," 

swap_string "$HOME/.sparrow/config" "useProxy" "\"useProxy\": true,"
fi
}