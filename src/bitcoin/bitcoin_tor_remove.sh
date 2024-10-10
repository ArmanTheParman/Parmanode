function bitcoin_tor_remove {
unset prefix
if [[ $OS == "Mac" ]] ; then
prefix=/usr/local 
fi

stop_bitcoin

delete_line "$prefix/etc/tor/torrc" "# Additions by Parmanode"
delete_line "$prefix/etc/tor/torrc" "bitcoin-service"
delete_line "$prefix/etc/tor/torrc" "127.0.0.1:8333"
delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

rm $HOME/.bitcoin/*onion* >$dn
start_bitcoin

set_terminal
echo "
Tor connection for Bitcoin disabled"
enter_continue
return 0

}