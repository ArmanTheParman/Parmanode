function bitcoin_conf_add {
delete_line "$1"
echo "$1" | tee -a $bc 
}

function bitcoin_conf_remove {
delete_line "$bc" "$1"
}