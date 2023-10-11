function menu_add_1 {
return 0
#for later


conf="$HOME/.parmanode/installed.conf"
while true
do
set_termianl
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Install Menu$orange                                  #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #"
if ! grep -q "bitcoin-end" < $conf ; then bitcoinmenu=1
echo "#                           (b)          Bitcoin Core                                  #" 
fi 
echo "#                                                                                      #
#                           ns)         Node Servers                                   #
#                                                                                      #
#                           w)          Wallets                                        #
#                                                                                      #
#                           nv)         Node viewers                                   #
#                                                                                      #
#                           l)          Lightning stuff                                #
#                                                                                      #
#                           o)          other stuff                                    #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpq" ; read choice
set_terminal

case $choice in
q|Q) exit ;; p|P) return 1 ;;

b|B) menu_bitcoin_core ;;

ns|NS|Ns) menu_node_servers ;;

w|W|wallets|Wallets) menu_wallets ;;

nv|Nv|NV) menu_node_viewers ;;

ls|LS|l) menu_lightning_stuff ;;

o|O|os|OS|Os) menu_other_stuff ;;

esac
done



}