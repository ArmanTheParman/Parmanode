function menu_electrum {
while true ; do set_terminal ; echo "
########################################################################################
                                Electrum Menu                               
########################################################################################

             (start)            Start Electrum 

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
run_electrum
return 0 ;;

*)
invalid
;;

esac
done
}
