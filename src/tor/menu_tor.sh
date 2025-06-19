function menu_tor {
which tor 1>$dn || return 1
while true ; do
clear

if [[ $OS == "Linux" ]] ; then 
    if sudo systemctl status tor >$dn 2>&1 ; then
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
########################################################################################$cyan                    
                                      TOR Menu   $orange
########################################################################################


                  STATUS:         Tor is $torrunningtext$orange



$green                  start)      $orange    Start Tor (normally starts automatically)

$red                  stop)         $orange  Stop Tor                  
                                                                 
$cyan                  restart)$orange        Restart Tor
                                                            

######################################################################################## 
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
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
"")
continue ;;
*)
invalid ;;
esac  
done
return 0
}