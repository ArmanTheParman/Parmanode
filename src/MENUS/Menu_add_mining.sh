function menu_add_mining {
while true

do
menu_add_source
set_terminal
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Mining Install $orange             #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
# Not yet installed...                                                                 #
#                                                                                      #"
if [[ -n $public_pool_n ]]         ; then echo  "$public_pool_n"; fi
echo "#                                                                                      #
# Installed...                                                                         #
#                                                                                      #"
if [[ -n $public_pool_i ]]   ; then echo  "$public_pool_i"; fi
echo "#                                                                                      #
# Failed installs (need to uninstall)...                                               #
#                                                                                      #"
if [[ -n $public_pool_p ]]   ; then echo -e "$pink$public_pool_p$orange"; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpmq"

read choice

case $choice in

    pool|Pool|POOL) 
        if [[ -n $public_pool_n ]] ; then
            install_public_pool
            return 0
        fi
        ;;

    m|M) back2main ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
    p|P)
        menu_add_new
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}
