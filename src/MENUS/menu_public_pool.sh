function menu_public_pool {

while true ; do 

if [[ -e $dp/tor/public_pool-tor ]]
get_onion_address "public_pool"
status_tor="${green}Enabled$orange"
else
status_tor="${red}Disabled$orange"
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

      (start)          Start Public Pool (and Public Pool UI) Docker containers

      (stop)           Stop Public Pool (and Public Pool UI) Docker containers

      (restart)        Restart containers

      (tor)            Enable/Disable Tor       $status_tor


      The user interfact can be access from your browser at:
$cyan
                       http://localhost:505${red}0$cyan  
                       http://127.0.0.1:505${red}1$cyan
                       https://127.0.0.1:505${red}2$cyan
                       https://$IP:505${red}2$cyan
$pink
                       ZMQ data available at port 5000 (not 3000) $orange

      Tor Access:$bright_blue      $ONION_ADDR_PP $orange
$cyan
IF YOU CAN'T CONNECT TO BITCOIN RPC MAKE SURE IT'S RUNNING THEN RESTART PUBLIC POOL$orange
########################################################################################
${red}r to refresh
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
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

*)
invalid
;;

esac
done
}
