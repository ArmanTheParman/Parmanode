function menu_add_new {
set_terminal

while true
do
menu_add_source
set_terminal_higher
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Install Menu$orange                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
#                          n)           Node Software                                  #
#                                                                                      #
#                          w)           Wallet Software                                #
#                                                                                      #
#                          o)           Other Software                                 #
#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice ; set_terminal

case $choice in

     n|N|node|Node)
        menu_add_node
        return 0
        ;;

    m) return 0 ;;

    w|W|wallets|Wallets)
        menu_add_wallets
        return 0
        ;;
   
    o|O|Other|OTHER)
        menu_add_other
        return 0
        ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
    p|P)
        return 0 
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}


 