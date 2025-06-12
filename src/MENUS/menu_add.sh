function menu_add {


check_disk_space
while true
do
if [[ $OS == "Linux" ]] && sudo fuser /var/lib/dpkg/lock-frontend >$dn 2>&1 ; then
announce "Careful, don't install anything while apt or apt-get is running"
fi
unset bitcoin_n menuaddnewbitcoin wordpress_available
menu_add_source

if [[ -z $bitcoin_n ]] ; then
bitcoin_new="#                                                                                      #"
menuaddnewbitcoin="false"
else
bitcoin_new="#                                                                                      #
#$cyan                      b)$orange           Bitcoin Knots/Core/Deis                            #
#                                                                                      #
#$cyan                     bs)$orange           Import own Bitcoin Core/Knots binaries             #
#                                                                                      #"
fi

if check_for_partial_installs ; then
    export partial_install="${red}Warning: You have partially installed programs. See Remove menu.$orange"
else
    unset partial_install
fi

set_terminal 34 88
echo -en "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Add (Install) Menu$orange                            #
#                                                                                      #
########################################################################################
# $partial_install \033[88G#
#                                                                                      #" ; echo ""
echo -en "${bitcoin_new}" ; echo -en "
#$cyan                      n)$orange           Node related software ...                          #
#                                                                                      #
#$blue                     pp)$blue           Premium ...        $orange                                #
#                                                                                      #
#$cyan                      w)$orange           Wallet Software ...                                #
#                                                                                      #
#$cyan                      o)$orange           Other Software ...                                 #
#                                                                                      #
#$cyan                      e)$orange           Extras ...                                         #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

express)
export express="true" #internal drive used initially for fast setup
install_bitcoin 
install_electrs
install_docker
install_mempool
install_electrum
install_sparrow

;;


B|b|bitcoin|Bitcoin)
        if [[ -z $menuaddnewbitcoin ]] ; then
        set_terminal 
        install_bitcoin
        menu_main
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

w|W|wallets|Wallets)
        menu_add_wallets
        return 0
        ;;

o|O|Other|OTHER)
        menu_add_other
        return 0
        ;;

e|E)
        menu_add_extras
        return 0
        ;;

pp)
        menu_premium
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

