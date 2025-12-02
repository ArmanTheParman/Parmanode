function bitcoin_conf_add { debugf
sudo gsed -i "/$1/d" $bc
echo "$1" | tee -a $bc 
}

function bitcoin_conf_remove { debugf
sudo gsed -i "/$1/d" $bc
}