function menu_add_new {
set_terminal

while true
do
unset bitcoin_n menuaddnewbitcoin
menu_add_source

if [[ -z $bitcoin_n ]] ; then
bitcoin_n="#                                                                                      #"
menuaddnewbitcoin=false
else
bitcoin_n="#$green                          b)           Bitcoin Core                                  $orange #"
fi

set_terminal_higher
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Install Menu$orange                                  #
#                                                                                      #
########################################################################################
#                                                                                      #"
echo -e "${bitcoin_n}
#                                                                                      #
#                          n)           Node related software ...                      #
#                                                                                      #
#                          w)           Wallet Software ...                            #
#                                                                                      #
#                          o)           Other Software ...                             #
#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice ; set_terminal

case $choice in

     B|b|bitcoin|Bitcoin)
        if [[ -z $menuaddnewbitcoin ]] ; then
        set_terminal 
        install_bitcoin
        return 0
        fi
        ;;
     n|N|node|Node)
        menu_add_node
        return 0
        ;;

m|M) back2main ;;

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
        back2main
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}


 