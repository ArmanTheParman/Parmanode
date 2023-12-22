function menu_tor {
while true ; do
set_terminal ; echo -e "
########################################################################################

                     $cyan                    TOR    $orange


                  status)         Check if Tor is running   $red - q to exit$orange

                  stop)           Stop Tor                  

                  start)          Start Tor (normally starts automatically)
                                                                 
                  restart)        Restart Tor
                                                            
######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) 
    exit 0 ;; 

p|P) 
menu_use ;; 

start|START) 
if [[ $OS == "Linux" ]] ; then sudo systemctl start tor && success "Tor" "starting" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services start tor  && success "Tor" "starting" ; return 0 ;fi ;;

stop|STOP) 
if [[ $OS == "Linux" ]] ; then sudo systemctl stop tor ; success "Tor" "stopping" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services stop tor ;  success "Tor" "stopping" ; return 0 ; fi ;;

status|STATUS) 
if [[ $OS == "Linux" ]] ; then sudo systemctl status tor ; enter_continue ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then true
    if brew services list | grep tor | grep "started" >/dev/null 2>&1 ; then set_terminal ; echo "Tor is running"
    enter_continue
    else
    set_terminal ; echo "Tor is not running"
    enter_continue
    return 0
    fi
fi
;;

restart|RESTART)
if [[ $OS == "Linux" ]] ; then sudo systemctl restart tor ; success "Tor" "restarting" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services restart tor ; success "Tor" "restarting" ; return 0 ; fi
;;

*)
invalid ;;
esac  

done
return 0
}