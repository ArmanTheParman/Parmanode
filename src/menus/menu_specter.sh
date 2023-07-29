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
run_specter
return 0 ;;

*)
invalid
;;

esac
done
}
