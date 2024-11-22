function menu_ledger {
if ! grep -q "ledger-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################$cyan
                                  Ledger Live Menu            $orange                   
########################################################################################

$green
         (start)$orange                  Start Ledger Live


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Ledger Live window should open soon."
run_ledger
return 0 ;;

*)
invalid
;;

esac
done
}
