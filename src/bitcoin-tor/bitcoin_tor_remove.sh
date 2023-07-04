function bitcoin_tor_remove {

if [[ $OS == "Mac" ]] ; then return 1 ; fi

stop_bitcoind

delete_line "/etc/tor/torrc" "# Additions by Parmanode"
delete_line "/etc/tor/torrc" "bitcoin-service"
delete_line "/etc/tor/torrc" "127.0.0.1:8332"
delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

sudo rm -rf /var/lib/tor/bitcoin*
rm $HOME/.bitcoin/*onion*
if which bitcoind ; then run_bitcoind ; fi

set_terminal
echo "
Tor connection for Bitcoin disabled"
enter_continue
return 0

}