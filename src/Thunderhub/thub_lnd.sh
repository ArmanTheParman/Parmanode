function thub_lnd {

export lnd_rpc_port=$(cat $HOME/.lnd/lnd.conf | grep -E '^rpclisten=' | grep -Eo ':.+' | tr -d :)

}

