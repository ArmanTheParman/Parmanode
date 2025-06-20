function menu_green {
if ! grep -q "green-end" $ic ; then return 0 ; fi
while true ; do set_terminal ; echo -e "
########################################################################################
                 $cyan              Green Wallet Menu            $orange                   
########################################################################################

$green
         start)$orange                 Start Green App 


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; m|M) back2main ;;

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
$hp/green/Blockstream*.AppImage >$dn 2>&1 &
fi
}