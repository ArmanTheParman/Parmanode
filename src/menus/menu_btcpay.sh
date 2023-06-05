function menu_btcpay {
while true ; do
set_terminal ; echo "
########################################################################################

                                  BTCPay Server

    The BTCPay server webpage is available to you via a browser on any device on this 
    network. Enter the following address to access:

                  http://${IP}:23001

########################################################################################

             pp)           BTC ParmanPay - Online payment app, worldwide access

             start)        Start BTCPay (starts Docker container)

             stop)         Stop BTCPay (stops Docker container)

             log)          View BTCPay Server log

             nl)           View NBXplorer log

######################################################################################## 
" 
choose "xpq" ; read choice ; set_terminal
case $choice in Q|q|QUIT|Quit|quit) exit 0 ;; p|P) return 0 ;;

start|START|Start)
if [[ $OS == "Linux" ]] ; then
docker start btcpay
startup_postgres && \
run_nbxplorer && \
run_btcpay
fi
;;

stop|STOP|Stop)
if [[ $OS == "Linux" ]] ; then docker stop btcpay ; fi
;;

log|Log|LOG)
echo "
########################################################################################
    
    This will show the BTCpay log file in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
tail -f $HOME/.btcpayserver/btcpay.log &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
continue ;;

nl|NL|Nl)
echo "
########################################################################################
    
    This will show the NBXplorer log file in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
tail -f $HOME/.nbxplorer/nbxplorer.log &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
continue ;;

pp|PP|Pp|pP)
btcparmanpay
;;

*)
invalid ;;
esac  

done
return 0
}