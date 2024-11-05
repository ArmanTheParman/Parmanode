function bitcoin_conf_add {
gsed -i "/$1/d" $bc
echo "$1" | tee -a $bc 
}

function bitcoin_conf_remove {
gsed -i "/$1/d" $bc
}