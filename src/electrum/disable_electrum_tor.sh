function disable_electrum_tor {

set_terminal
echo "Make sure Electrum has been completely shut down before proceeding."
enter_continue

gsed -i "/\"server/c\    \"server\": \"127.17.0.2:50002:s\"," $HOME/.electrum/config
sudo gsed "/proxy/d" $HOME/.electrum/config

success "Electrum Wallet" "being disconnected from Tor."

return 0
}
