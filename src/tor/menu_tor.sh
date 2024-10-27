function menu_tor {
while true ; do

if [[ $OS == "Linux" ]] ; then 
    if sudo systemctl status tor | grep Active: | grep -q active ; then
    torrunning="true"
    torrunningtext="${green}RUNNING"
    else
    torrunning="false"
    torrunningtext="${red}NOT RUNNING"
    fi
fi

if [[ $OS == "Mac" ]] ; then true
    if brew services list | grep tor | grep -q "started" ; then 
    torrunning="true"
    torrunningtext="${green}RUNNING"
    else
    torrunning="false"
    torrunningtext="${red}NOT RUNNING"
    fi
fi

set_terminal ; echo -e "
########################################################################################

                     $cyan                    TOR    $orange

########################################################################################


                  STATUS:         Tor is $torrunningtext$orange



$green                  stop)         $orange  Stop Tor                  

$red                  start)      $orange    Start Tor (normally starts automatically)
                                                                 
$cyan                  restart)$orange        Restart Tor
                                                            

######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;; Q|q|QUIT|Quit|quit) exit 0 ;; p|P) menu_use ;; 

start|START) 
start_tor
;;

stop|STOP) 
stop_tor
;;

restart|RESTART)
restart_tor
;;

*)
invalid ;;
esac  
done
return 0
}