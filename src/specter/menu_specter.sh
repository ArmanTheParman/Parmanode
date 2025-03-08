function menu_specter {
if ! grep -q "specter-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan                Specter Menu            $orange                   
########################################################################################

$green
                 (start)$orange                 Start Specter 


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Specter window should open soon."
run_specter
return 0 ;;
"")
continue ;;
*)
invalid
;;

esac
done
}
