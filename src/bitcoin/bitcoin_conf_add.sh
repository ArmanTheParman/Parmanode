function bitcoin_conf_add {
add_it=$1
delete_line "$add_it"
echo "$add_it" | tee -a $HOME/.bitcoin/bitcoin.conf
return 0
}