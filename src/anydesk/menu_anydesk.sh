function menu_anydesk {
if ! grep -q "anydesk-end" $ic ; then return 0 ; fi
 while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan               AnyDesk Menu            $orange                   
########################################################################################


         (start)                Start AnyDesk 


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
m|M) back2main ;;

start|Start|START|S|s)
check_SSH || return 0
start_anydesk
return 0 ;;
"")
continue ;;
*)
invalid
;;

esac
done
} 