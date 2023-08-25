function menu_mempool {
while true ; do set_terminal ; echo "
########################################################################################
                                Mempool Space Menu                               
########################################################################################
"
if docker ps | grep mempool >/dev/null 2>&1 ; then echo "
                   MEMPOOL IS RUNNING -- SEE LOG MENU FOR PROGRESS "
else
echo "
                   MEMPOOL IS NOT RUNNING -- CHOOSE \"start\" TO RUN"
fi
echo "

      (start)          Start Mempool Space 

      (stop)           Stop Mempool Space 

       
      To see Mempool Space, navigate to http://$IP:4080


########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|START|Start) cd $HOME/parmanode/mempool/docker && docker compose start api web db ; enter_continue ; return 1 ;;
stop|STOP|Stop) cd $HOME/parmanode/mempool/docker && docker compose stop api web db ; enter_continue ; return 1 ;; 
*) invalid ;;
esac ; done 
}