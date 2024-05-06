function thub_lnd {

export lnd_rpc_port=$(cat $HOME/.lnd/lnd.conf | grep -E '^rpclisten=' | grep -Eo ':.+' | tr -d :)
swap_string "$file" "SSO_SERVER_URL=" "SSO_SERVER_URL='127.0.0.1:$lnd_rpc_port'"

swap_string "$file" "SSO_CERT_PATH=" "SSO_CERT_PATH=$HOME/.lnd/tls.cert"   

#path, not file
swap_string "$file" "SSO_MACAROON_PATH=" "SSO_MACAROON_PATH=$HOME/.lnd/data/chain/bitcoin/mainnet/"

}

