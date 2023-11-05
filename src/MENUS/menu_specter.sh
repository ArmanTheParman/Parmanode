function menu_specter {
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan                Specter Menu            $orange                   
########################################################################################


         (start)                 Start Specter 


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Specter window should open soon."
run_specter
enter_continue
return 0 ;;

*)
invalid
;;

esac
done
}
