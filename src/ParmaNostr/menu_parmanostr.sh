function menu_parmanostr {
 while true ; do set_terminal ; echo -e "
########################################################################################
                   $cyan               Parmanostr Menu            $orange                   
########################################################################################

$cyan
              (w)$orange                 See wallet info 


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; m|M) back2main ;;
w)
parmanostr_wallet_info
;;
*)
invalid
;;
esac
done
} 