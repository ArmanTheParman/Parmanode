function menu_tor {
while true ; do
set_terminal ; echo -e "
########################################################################################

                     $cyan                    TOR    $orange

                       status)         Check if Tor is running   $red - q to exit$orange

                       stop)           Stop Tor                  $red - q to exit$orange 

                       start)          Start Tor (normally starts automatically)
                                                                 $red - q to exit$orange
                       restart)        Restart Tor
                                                                 $red - q to exit$orange

######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) 
    exit 0 ;; 

p|P) menu_use ;; 

start|START) 
if [[ $OS == "Linux" ]] ; then sudo systemctl start tor && success "Tor" "starting" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services start tor  && success "Tor" "starting" ; fi ;;

stop|STOP) 
if [[ $OS == "Linux" ]] ; then sudo systemctl stop tor ; success "Tor" "stopping" ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services stop tor ;  success "Tor" "stopping" ; fi ;;

status|STATUS) 
if [[ $OS == "Linux" ]] ; then sudo systemctl status tor ; enter_continue ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then true
    if brew services list | grep tor | grep "started" >/dev/null 2>&1 ; then set_terminal ; echo "Tor is running"
    enter_continue
    else
    set_terminal ; echo "Tor is not running"
    enter_continue
    fi
fi
;;

*)
invalid ;;
esac  

done
return 0
}