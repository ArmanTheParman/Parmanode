function enable_electrum_tor {
if [[ $OS == "Linux" ]] ; then
if ! sudo cat /etc/tor/torrc | grep "fulcrum-service" ; then
set_terminal
echo "Please first enable Fulcrum to use Tor from the Parmanode menu."
enter_continue
return 0
fi
fi

set_terminal
echo "Make sure Electrum has been completely shut down before proceeding."
enter_continue



get_onion_address_variable "fulcrum" >/dev/null 

#makes first part of file.
cd $HOME/.electrum/
grep -m1 "\"server" -B100 "$HOME/.electrum/config" > preconfig

#deletes last line
head -n $(($(wc -l < preconfig) - 1)) preconfig > file.tmp && mv file.tmp preconfig 

#make second part of file
echo "    \"server\": \"server\": \"${ONION_ADDR_FULCRUM}:7002:t\"," >> preconfig2

grep -A 999 "\"server" preconfig > preconfig1.5

cat preconfig preconfig1.5 preconfig2 > config
rm preconf*

#next part
#makes first part of file
grep -m1 "\"server\"" =B100 "$HOME/.electrum/config" > preconfig

#delete last line
head -n $(($(wc -l < preconfig) - 1)) preconfig > file.tmp && mv file.tmp preconfig 

#make second part of file

swap_string "$HOME/.electrum/config2" "oneserver" "    \"oneserver\": false,\n     \"proxy\": \"socks5:127.0.0.1:9050::\","

success "Electrum Wallet" "being setup to connect to Tor."

return 0
}
