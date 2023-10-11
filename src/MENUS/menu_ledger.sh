function menu_ledger {
while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                                  Ledger Live Menu            $orange                   
########################################################################################


         (start)                  Start Ledger Live


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Ledger Live window should open soon."
run_ledger
enter_continue
return 0 ;;

*)
invalid
;;

esac
done
}
