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
case $choice in Q|q|QUIT|Quit|quit) exit 0 ;; p|P) return 0 ;;

start|START) sudo systemctl start tor ; return 0 ;;
stop|STOP) sudo systemctl stop tor return 0 ;;
status|STATUS) sudo systemctl status tor return 0 ;;

*)
invalid ;;
esac  

done
return 0
}