function menu_torssh {
if ! grep -q "torssh-end" $ic ; then return 0 ; fi
get_onion_address_variable ssh

while true ; do 
set_terminal ; echo -e "
########################################################################################
        $cyan                    SSH Tor Server Menu $orange
########################################################################################

   SSH Command to access this computer:
$bright_blue
   ssh $USER@$ONION_ADDR_SSH $red $blinkon 
   Keep this onion address private, it's access to your computer. $blinkoff $orange

   The only thing defending your home network after this onion address is your
   probably weak computer login password.

$orange   
   The client computer accessing here needs to have this directive in ~/.ssh/config 
   and make sure ncat is installed on the system. If the config file doesn't exist,
   then create it ... $cyan

   Host *.onion
   ProxyCommand ncat --proxy 127.0.0.1:9050 --proxy-type socks5 %h %p
$orange
   Expect the interaction to be very slow.



$green                        (rt)$orange            Restart Tor

$green                        (rs)$orange            Restart SSH Service



########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
rt|RT|Rt) sudo systemctl restart tor.service ;;
rs) sudo systemctl restart ssh ;;
"")
continue ;;
*)
invalid
;;
esac
done
}