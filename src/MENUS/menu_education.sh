function menu_education {

while true ; do
set_terminal
echo -e "
########################################################################################
 
$cyan
                            P A R M A N O D E - Education
$orange
                    
                    (w)        How to connect your wallet to the node

                    (m)        Bitcoin Mentorship Info

                    (n)        Six reasons to run a node

                    (s)        Seperation of money and state

                    (cs)       Cool stuff

            .... more soon


########################################################################################
"
choose "xpmq" ; read choice

case $choice in

    m) return 0 ;;

    w|W)
        connect_wallet_info
        ;;
    m|M)
        mentorship
        ;;
    n|N|node|Node)
        # the less function inside the custom less_function takes a variable to know which file to print.
        less_function "6rn"
        ;;
    s|S)
        less_function "joinus"
        ;;
    cs|CS|Cs)
        cool_stuff
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
