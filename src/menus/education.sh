function education {

while true ; do
set_terminal
echo "
########################################################################################
 

                              P A R M A N O D E - Education

                    
                    (w)        How to connect your wallet to the node

                    (m)        Bitcoin Mentorship Info

                    (n)        Six reasons to run a node

            .... more soon


########################################################################################
"
choose "xpq" ; read choice

case $choice in
    w|W)
        connect_wallet_info
        ;;
    m|M)
        mentorship
        ;;
    n|N|node|Node)
        6reasons_node 
        ;;
    p|P)
        return 0
        ;;
    q|Q|Quit|QUIT)
        exit 0
        ;;
    *)
        invalid 
        ;;

esac
done
return 0
}
