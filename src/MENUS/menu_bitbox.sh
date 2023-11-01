function menu_bitbox {
 while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan                Bitbox Menu            $orange                   
########################################################################################


         (start)                 Start BitBox App 


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
m) back2main ;;

start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A BitBox App window should open soon."
run_bitbox
enter_continue
return 0 ;;

*)
invalid
;;

esac
done
} 