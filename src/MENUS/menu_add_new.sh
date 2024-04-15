function menu_add_new {
set_terminal

check_disk_space


while true
do
unset bitcoin_n menuaddnewbitcoin wordpress_available
menu_add_source

if [[ -z $bitcoin_n ]] ; then
bitcoin_new="#                                                                                      #"
menuaddnewbitcoin=false
else
bitcoin_new="#                                                                                      #
#$green                          b)           Bitcoin Core                                  $orange #
#                                                                                      #
#$bright_blue                          bs)          Import own Bitcoin Core binaries              $orange #
#                                                                                      #"
fi

if ! grep "website-" < $ic ; then
wordpress_available="#$bright_blue                          ws)          WordPress Server (ParmaWeb) $green$blinkon NEW!$blinkoff $orange             #
#                                                                                      #"
else
unset wordpress_available
wordpress_available="#                                                                                      #"
fi

set_terminal_higher
echo -en "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Install Menu$orange                                  #
#                                                                                      #
########################################################################################"
echo -en "${bitcoin_new}
#                                                                                      #
#                          n)           Node related software ...                      #
#                                                                                      #
#                          w)           Wallet Software ...                            #
#                                                                                      #
#                          mm)          Mining Software ...                            #
#                                                                                      #
#                          o)           Other Software ...                             #
#                                                                                      #
#                          cool)        Cool stuff ...                                 #
#                                                                                      #
$wordpress_available
########################################################################################
"
choose "xpmq"
if [[ $1 == wth ]] ; then choice=wth
else
read choice 
fi
set_terminal

case $choice in

B|b|bitcoin|Bitcoin)
        if [[ -z $menuaddnewbitcoin ]] ; then
        set_terminal 
        install_bitcoin
        return 0
        fi
        ;;

bs|BS|Bs|bS)
        if [[ -z $menuaddnewbitcoin ]] ; then
        set_terminal 
        import_bitcoin_install
        return 0
        fi
        ;;

n|N|node|Node)
        menu_add_node
        return 0
        ;;

mm|MM|Mm|mM)
        menu_add_mining
        return 0
        ;;

m|M) back2main ;;

w|W|wallets|Wallets)
        menu_add_wallets
        return 0
        ;;
wth)
        menu_add_wallets th
        return 0 
        ;;
o|O|Other|OTHER)
        menu_add_other
        return 0
        ;;

cool|COOL|c)
        menu_coolstuff
        return 0
        ;;

ws)
        install_website
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

