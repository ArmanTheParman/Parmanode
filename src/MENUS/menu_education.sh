function menu_education {

while true ; do
set_terminal
echo -e "
########################################################################################
 
$cyan
                            P A R M A N O D E - Education
$orange
                    
                    (mit)      2018 MIT Lecture Series (With Tagde Dryja)

                    (w)        How to connect your wallet to the node

                    (mm)       Bitcoin Mentorship Info

                    (n)        Six reasons to run a node

                    (s)        Separation of money and state

                    (cs)       Cool stuff

            .... more soon


########################################################################################
"
choose "xpmq" ; read choice

case $choice in

m|M) back2main ;;
    mit)
        mit_lectures
        ;;

    w|W)
        connect_wallet_info
        ;;
    mm|MM|mM|Mm)
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

    p|P) menu_use ;; 

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
