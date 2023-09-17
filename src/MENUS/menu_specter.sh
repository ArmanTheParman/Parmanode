function menu_specter {
while true ; do set_terminal ; echo "
########################################################################################
                                 Specter Menu                               
########################################################################################


         (start)                 Start Specter 


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
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
