function menu_tor_bitcoin {

if ! which tor >/dev/null 2>&1 ; then set_terminal
echo "
    You need to install Tor first. Aborting.
    "
enter_continue
fi

while true ; do
set_terminal ; echo -e "
########################################################################################

$cyan                        Tor options for Bitcoin (Linux only)   $orange


     1)    Allow Tor connections AND clearnet connections
                 - Helps you and the network overall

     2)    Force Tor only connections
                 - Extra private but only helps the Tor network of nodes
    
     3)    Force Tor only OUTWARD connections
                 - Only helps yourself but most private of all options
                 - You can connect to tor nodes, they can't connect to you

     4)    Make Bitcoin public (Remove Tor usage and stick to clearnet)
                 - Generally faster and more reliable
                
"
if sudo [ -f /var/lib/tor/bitcoin-service/hostname ] ; then 
get_onion_address_variable >/dev/null ; echo "

    Onion adress: $ONION_ADDR 



########################################################################################
"
else echo "########################################################################################
"
fi

choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|quit|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
"1")
    bitcoin_tor "torandclearnet" 
    check_bitcoin_tor_status #sets status in parmanode.conf
    return 0 ;;
"2")
    bitcoin_tor "toronly" 
    check_bitcoin_tor_status
    return 0 ;;
"3")
    bitcoin_tor "toronly" "onlyout" 
    check_bitcoin_tor_status
    return 0 ;;
"4")
    bitcoin_tor_remove 
    check_bitcoin_tor_status
    return 0 ;;
*)
    invalid ;;
esac
done
}

