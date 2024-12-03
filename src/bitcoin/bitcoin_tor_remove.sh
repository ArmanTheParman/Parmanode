function bitcoin_tor_remove {


stop_bitcoin
#delete...
sudo gsed -i  "/# Additions by Parmanode/d" $macprefix/etc/tor/torrc
sudo gsed -i  "/bitcoin-service/d"          $macprefix/etc/tor/torrc
sudo gsed -i  "/127.0.0.1:8333/d"           $macprefix/etc/tor/torrc
sudo gsed -i  "/onion/d"                    $bc 
sudo gsed -i  "/bind=127.0.0.1/d"           $bc
sudo gsed -i  "/onlynet/d"                  $bc

add_rpcbind

rm $HOME/.bitcoin/onion* >$dn
start_bitcoin

set_terminal
enter_continue "Ligação Tor para Bitcoin desactivada"
return 0

}
