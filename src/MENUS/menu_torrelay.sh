function menu_torrelay {
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan              Tor Relay Menu            $orange                   
########################################################################################


               i)        Tor Relay Information

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
i|I|info|Info|INFO)
#relay_info
return 0 ;;

*)
invalid
;;

esac
done
}