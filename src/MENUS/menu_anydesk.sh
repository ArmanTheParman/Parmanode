function menu_anydesk {
 while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan               AnyDesk Menu            $orange                   
########################################################################################


         (start)                Start AnyDesk 


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
check_SSH || return 0
start_anydesk
return 0 ;;

*)
invalid
;;

esac
done
} 