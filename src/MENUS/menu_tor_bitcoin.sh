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
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=t&c"
    return 0 ;;
"2")
    bitcoin_tor "toronly" 
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=t"
    return 0 ;;
"3")
    bitcoin_tor "toronly" "onlyout" 
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=tonlyout"
    return 0 ;;
"4")
    bitcoin_tor_remove 
    parmanode_conf_remove "bitcoin_tor_status="
    parmanode_conf_add "bitcoin_tor_status=c"
    return 0 ;;
*)
    invalid ;;
esac
done
}

