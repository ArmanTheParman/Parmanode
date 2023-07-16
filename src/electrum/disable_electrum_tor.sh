function disable_electrum_tor {

set_terminal
echo "Make sure Electrum has been completely shut down before proceeding."
enter_continue

swap_string "$HOME/.electrum/config" "\"server" "    \"server\": \"127.17.0.2:50002:s\","
delete_line "$HOME/.electrum/config" "proxy"

success "Electrum Wallet" "being disconnected from Tor."

return 0
}
