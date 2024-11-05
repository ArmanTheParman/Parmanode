function bitcoin_conf_remove {
gsed -i "/$1/d" $bc
}