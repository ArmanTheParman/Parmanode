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
sudo gsed -i  "/onion/d"                    $HOME/.bitcoin/bitcoin.conf
sudo gsed -i  "/bind=127.0.0.1/d"           $HOME/.bitcoin/bitcoin.conf
sudo gsed -i  "/onlynet/d"                  $HOME/.bitcoin/bitcoin.conf

add_rpcbind

rm $HOME/.bitcoin/onion* >$dn
start_bitcoin

set_terminal
echo "
Tor connection for Bitcoin disabled"
enter_continue
return 0

}