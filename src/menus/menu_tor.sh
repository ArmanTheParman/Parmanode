function menu_tor {
while true ; do
set_terminal ; echo "
########################################################################################

                                  TOR

                       status)         Check if Tor is running

                                           - q to exit

                       stop)           Stop Tor 

                                           - q to exit

                       start)          Start Tor (normally starts automatically)

                                           - q to exit
  
######################################################################################## 
"
choose "xpq" ; read choice
case $choice in 
Q|q|QUIT|Quit|quit) 
    exit 0 ;; 

p|P) 
    return 0 ;;

start|START) 
if [[ $OS == "Linux" ]] ; then sudo systemctl start tor ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services start tor ; return 0 ; fi ;;

stop|STOP) 
if [[ $OS == "Linux" ]] ; then sudo systemctl stop tor ; return 0 ; fi
if [[ $OS == "Mac" ]] ; then brew services stop tor ; return 0 ; fi ;;

status|STATUS) 
if [[ $OS == "Linux" ]] ; then sudo systemctl status tor ; return 0 ; fi
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