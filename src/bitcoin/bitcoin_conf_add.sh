function bitcoin_conf_add {
sudo gsed -i "/$1/d" $bc
echo "$1" | tee -a $bc 
}

function bitcoin_conf_remove {
sudo gsed -i "/$1/d" $bc
}