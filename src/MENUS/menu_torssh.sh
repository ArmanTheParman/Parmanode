function menu_torssh {

get_onion_address_variable ssh

while true ; do 
set_terminal ; echo -e "
########################################################################################
        $cyan               SSH Tor Server Menu $orange
########################################################################################

   SSH Command to access this computer:
$bright_blue
   $USER@$ONION_ADDR_SSH
$orange
                        (rt)            Restart Tor

                        (rs)            Restart SSH Service

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
rt|RT|Rt) sudo systemctl restart tor.service ;;
rs) sudo systemctl restart ssh ;;
*)
invalid
;;
esac
done
}