function menu_parmabox {
 while true ; do set_terminal ; echo -e "
########################################################################################
              $cyan              ParmaBox Menu            $orange                   
########################################################################################




########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Trezor Suite window should open soon."
run_trezor
enter_continue
return 0 ;;

*)
invalid
;;

esac
done
} 