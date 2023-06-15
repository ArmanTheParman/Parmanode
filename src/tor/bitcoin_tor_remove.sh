function bitcoin_tor_remove {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

stop_bitcoind

delete_line "/etc/tor/torrc" "# Additions by Parmanode"
delete_line "/etc/tor/torrc" "bitcoin-service"
delete_line "/etc/tor/torrc" "127.0.0.1:8332"
delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

run_bitcoind

set_terminal
echo "
Bitcoin changes have been made and the program has been restarted."
enter_continue
return 0

}