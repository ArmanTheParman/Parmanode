function bitcoin_tor_remove {
unset prefix
if [[ $OS == "Mac" ]] ; then
prefix=/usr/local 
fi

stop_bitcoin
#delete...
sudo gsed -i  "/# Additions by Parmanode/d" $prefix/etc/tor/torrc
sudo gsed -i  "/bitcoin-service/d"          $prefix/etc/tor/torrc
sudo gsed -i  "/127.0.0.1:8333/d"           $prefix/etc/tor/torrc
sudo gsed -i  "/onion/d"                    $bc 
sudo gsed -i  "/bind=127.0.0.1/d"           $bc
sudo gsed -i  "/onlynet/d"                  $bc

add_rpcbind

rm $HOME/.bitcoin/onion* >$dn
start_bitcoin

set_terminal
enter_continue "Tor connection for Bitcoin disabled"
return 0

}