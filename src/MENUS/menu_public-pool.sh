function menu_public-pool {

while true ; do 
set_terminal ; echo -e "
########################################################################################$cyan
                                 Public Pool Menu     $orange 
########################################################################################
"
if docker ps | grep -q public-pool ; then echo -e "
                             Public Pool is $greenRUNNING$orange" 
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
                       http://localhost:5050  $orange Note 127.0.0.1:5050 won't work

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;

q|Q|QUIT|Quit) exit 0 ;;

p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

start|Start|START|S|s)
start_public-pool
continue
;;

stop|STOP|Stop)
stop_public-pool
continue
;;

restart|RESTART|Restart)
stop_public-pool
start_public-pool
continue
;;

*)
invalid
;;

esac
done
}
