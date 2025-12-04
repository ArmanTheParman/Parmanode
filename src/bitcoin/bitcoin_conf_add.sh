function bitcoin_conf_add { debugf
$xsudo gsed -i "/$1/d" $bc
echo "$1" | tee -a $bc 
}

function bitcoin_conf_remove { debugf
$xsudo gsed -i "/$1/d" $bc
}