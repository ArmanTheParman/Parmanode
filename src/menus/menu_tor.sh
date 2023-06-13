function menu_tor {
while true ; do
set_terminal ; echo "
########################################################################################

                        Tor options for Bitcoin (Linux only)


     1)    Allow Tor connections and clearnet connections
                 - Helps you and the network overall

     2)    Force Tor only connections
                 - Extra private but only helps the Tor network of nodes
    
     3)    Force Tor only OUTWARD connections
                 - Only helps yourself but most private of all options
                 - You can connect to tor nodes, they can't connect to you

     4)    Make Bitcoin public (Remove Tor usage and stick to clearnet)
                 - Generally faster and more reliable
                
"
if which tor ; then echo "
________________________________________________________________________________________

    5)    What's my onion address?

########################################################################################
"
else echo "########################################################################################
"
fi

choose "xpq" ; read choice
case $choice in 
Q|q|quit|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
"1")
    bitcoin_tor "torandclearnet" ; return 0 ;;
"2")
    bitcoin_tor "toronly" ; return 0 ;;
"3")
    bitcoin_tor "toronly" "onlyout" ; return 0 
    true ;;
"4")
    true ;;
"5")
    set_terminal
    sudo cat /var/lib/tor/bitcoin-service/hostname
    enter_continue
    return 0
    ;;
*)
    invalid ;;
esac
done
}