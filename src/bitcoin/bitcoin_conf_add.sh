function bitcoin_conf_add {
add_it=$1

echo "$add_it" | tee -a $HOME/.bitcoin/bitcoin.conf
return 0
}