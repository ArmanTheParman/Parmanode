function thub_lnd {

lnd_rpc_port=$(cat $HOME/.lnd/lnd.conf | grep -E '^rpclisten=' | grep -Eo ':.+' | tr -d :)
"SSO_SERVER_URL='127.0.0.1:$lnd_rpc_port'"
rpclisten=localhost:10009
rpclisten=localhost:10009
}

