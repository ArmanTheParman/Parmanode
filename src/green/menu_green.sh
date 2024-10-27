function menu_green {
 while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan              Green Wallet Menu            $orange                   
########################################################################################

$green
         (start)$orange                 Start Green App 


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
m|M) back2main ;;

start|Start|START|S|s)
check_SSH || return 0
please_wait ; echo "" ; echo "A Green Wallet App window should open soon."
run_green
return 0 ;;

*)
invalid
;;

esac
done
} 


function run_green {
if [[ $OS == Mac ]] ; then
open /Applications/Blockstream*app
elif [[ $OS == Linux ]] ; then
$hp/green/Blockstream*.AppImage >/dev/null 2>&1 &
fi
}