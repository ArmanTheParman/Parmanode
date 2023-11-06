function menu_trezor {
 while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan                Trezor Menu            $orange                   
########################################################################################


         (start)                 Start Trezor Suite 


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
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