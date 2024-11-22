function menu_public_pool {
if ! grep -q "public_pool-end" $ic ; then return 0 ; fi
while true ; do 
unset status_tor_text status_tor ONION_ADDR_PP tor_URL

if sudo cat /etc/tor/torrc | grep -q 127.0.0.1:5052 ; then
      get_onion_address_variable "public_pool"
      status_tor_text="${green}Enabled$orange"
      status_tor=enabled
      tor_URL="      https://$ONION_ADDR_PP:5055 $orange"
else
      status_tor_text="${red}Disabled$orange"
      status_tor=disabled
fi


set_terminal ; echo -e "
########################################################################################$cyan
                                 Public Pool Menu     $orange 
########################################################################################
"
if docker ps 2>/dev/null | grep -q public_pool ; then echo -e "
                             Public Pool is ${green}RUNNING$orange" 
else 
echo -e "
                           Public Pool is$red NOT RUNNING$orange" 
fi
echo -e "      
$green
      (start)$orange          Start Public Pool (and Public Pool UI) Docker containers
$red
      (stop)$orange           Stop Public Pool (and Public Pool UI) Docker containers
$cyan
      (restart)$orange        Restart containers
$cyan
      (tor)$orange            Enable/Disable Tor       $status_tor_text
$cyan
      (newtor)$orange         Refresh onion address


      The user interfact can be access from your browser at:
$cyan
                   http://localhost:505${red}0$cyan  
                   http://127.0.0.1:505${red}1$cyan
                   https://127.0.0.1:505${red}2$cyan
                   https://$IP:505${red}2$cyan

      Tor Access (SSL):$bright_blue  
$tor_URL
$cyan
  IF YOU CAN'T CONNECT TO BITCOIN RPC MAKE SURE IT'S RUNNING THEN RESTART PUBLIC POOL$orange
########################################################################################
${red}r to refresh
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
r) menu_public_pool ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

start|Start|START|S|s)
start_public_pool
continue
;;

stop|STOP|Stop)
stop_public_pool
continue
;;

restart|RESTART|Restart)
stop_public_pool
start_public_pool
continue
;;

tor)
if [[ $status_tor == disabled ]] ; then
enable_tor_public_pool
else
disable_tor_public_pool
fi
;;

newtor)
sudo rm -rf /var/lib/tor/public_pool-service
debug "rm tor dir"
sudo systemctl restart tor
announce "You need to wait about 30 seconds to a minute for the onion address to appear.
    Just refresh the menu after a while."
;;

*)
invalid
;;

esac
done
}
