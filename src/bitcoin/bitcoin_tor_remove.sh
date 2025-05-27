function bitcoin_tor_remove {

nogsedtest

stop_bitcoin
#delete...
sudo gsed -i  "/# Additions by Parmanode/d" $macprefix/etc/tor/torrc
sudo gsed -i  "/bitcoin-service/d"          $macprefix/etc/tor/torrc
sudo gsed -i  "/127.0.0.1:8333/d"           $macprefix/etc/tor/torrc
sudo gsed -i  "/onion/d"                    $bc 
echo "listenonion=0" | tee -a $bc >$dn 2>&1
sudo gsed -i  "/bind=127.0.0.1/d"           $bc
sudo gsed -i  "/onlynet/d"                  $bc


add_rpcbind #adds 0.0.0.0

rm $HOME/.bitcoin/onion* >$dn
start_bitcoin
parmanode_conf_remove "bitcoin_tor_status"
set_terminal
enter_continue "Tor connection for Bitcoin disabled"
return 0

}