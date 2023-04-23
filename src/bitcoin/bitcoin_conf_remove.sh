function bitcoin_conf_remove {
remove_it=$1

delete_line "$HOME/.bitcoin/bitcoin.conf" "$remove_it"

return 0
}