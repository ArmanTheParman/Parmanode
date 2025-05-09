function menu_trezor {
if ! grep -q "trezor-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan                Trezor Menu            $orange                   
########################################################################################

$green
         start)$orange                 Start Trezor Suite 


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Trezor Suite window should open soon."
run_trezor 
return 0 ;;
"")
continue ;;
*)
invalid
;;
esac
done
} 