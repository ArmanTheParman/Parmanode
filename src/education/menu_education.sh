function menu_education {

while true ; do
set_terminal
echo -ne "
########################################################################################$cyan

                            P A R M A N O D E - Education $orange

########################################################################################

$cyan                    
                    mit)$orange      2018 MIT Lecture Series (With Tagde Dryja)
$cyan
                    w)$orange        How to connect your wallet to your node
$cyan
                    mm)$orange       Bitcoin Mentorship Info
$cyan
                    n)$orange        Six reasons to run a node (essay)
$cyan
                    s)$orange        Separation of money and state (essay)
$cyan
                    cs)$orange       Cool stuff ('Did you know?')


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

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

    *)
        invalid 
        ;;

esac
done
return 0
}
