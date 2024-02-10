function menu_public_pool {

while true ; do 
set_terminal ; echo -e "
########################################################################################$cyan
                                 Public Pool Menu     $orange 
########################################################################################
"
if docker ps | grep -q public_pool ; then echo -e "
                             Public Pool is ${green}RUNNING$orange" 
else 
echo -e "
                           Public Pool is$red NOT RUNNING$orange" 
fi
echo -e "      

      (start)          Start Public Pool (and Public Pool UI) Docker containers

      (stop)           Stop Public Pool (and Public Pool UI) Docker containers

      (restart)        Restart containers


      The user interfact can be access from your browser at:
$cyan
                       http://localhost:5050  $red Note 127.0.0.1:5050 won't work$orange
$pink
                       ZMQ data available at port 5000 (not 3000) $orange

$bright_blue                       TOR coming soon $orange

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) bacq
k2main ;;

q|Q|QUIT|Quit) exit 0 ;;

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
