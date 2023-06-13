function menu_tor {
while true ; do
set_terminal ; echo "
########################################################################################

                              Tor options for Bitcoin


     1)    Allow Tor connections and clearnet connections
                 - Helps you and the network overall

     2)    Force Tor only connections
                 - Extra private but only helps the Tor network of nodes
    
     3)    Force Tor only OUTWARD connections
                 - Only helps yourself but most private of all options
                 - You can connect to tor nodes, they can't connect to you

     4)    Make Bitcoin public (Remove Tor usage and stick to clearnet)
                 - Generally faster and more reliable

########################################################################################
"
choose "xpq" ; read choice
esac Q|q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
"1")
    true ;;
"2")
    true ;;
"3")
    true ;;
"4")
    true ;;
*)
    invalid ;;
esac
done

}