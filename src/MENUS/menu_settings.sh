function menu_settings {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                   SETTINGS    $orange

         c)        Change colours

######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) exit 0 ;; 
p|P) return ;;

c|C) change_colours ; return 0 ;;
*) invalid ;;
esac
done
}