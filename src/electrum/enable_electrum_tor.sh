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

if [[ $OS == "Linux" ]] ; then
get_onion_address_variable "fulcrum" >/dev/null 
fi

if [[ $OS == "Mac" ]] ; then
    set_terminal ; 
    echo "Please paste in the onion address for your Fulcrum/Electrum server you wish to use."
    echo "Note this is not the onion address for your Bitcoin Node. It's for Fulcrum/Electrum."
    echo "You need the long string plus the ending \".onion\". If there is a port number for"
    echo "the address, then include that as well. For example:"
    echo "wcyj5idoz7ohlpvmaltoppe1h2nc6j46npghyyls2cqxs7yoquwyjmy4.onion:7002"
    echo "After pasting the address, hit <enter>."
    read ONION_ADDR_FULCRUM
    set_terminal
    echo "Do you use Tor by a browser (b) or daemon (d). Please choose, then <enter>."
    read portchoice
    if [[ $portchoice == "b"  ]] ; then
        port="9150"
    fi
    if [[ $portchoice == "d"  ]] ; then
        port="9050"
    fi
fi

change_string_mac "$HOME/.electrum/config" "\"server"  "    \"server\": \"${ONION_ADDR_FULCRUM}:t\"," swap
change_string_mac "$HOME/.electrum/config" proxy null delete
change_string_mac "$HOME/.electrum/config" oneserver "    \"proxy\": \"socks5:127.0.0.1:$port\"," after

success "Electrum Wallet" "being setup to connect to Tor."

return 0
}
