function menu_btcpay {
while true ; do
set_terminal_custom 48 ; echo -e "
########################################################################################
                                 ${cyan}BTCPay Server Menu${orange}
########################################################################################

"
if docker ps | grep btcp >/dev/null 2>&1 ; then echo -e "
                  BTCPay SERVER IS$green RUNNING$orange -- SEE LOG MENU FOR PROGRESS "
else
echo -e "
                  BTCPay SERVER IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi
echo -e "


             pp)           BTC ParmanPay - Online payment app, worldwide access

             start)        Start BTCPay (starts Docker container)

             stop)         Stop BTCPay (stops Docker container)

             restart)      Restart BTCPay (restarts Docker container)

             c)            Connect BTCPay to LND

             bc)           BTCPay config file

             nc)           NBXplorer config file

             log)          View BTCPay Server log

             nl)           View NBXplorer log




    To access:     http://${IP}:23001$yellow     
                                              from any computer on home network    $orange

    OR:            http://localhost:23001$yellow 
                                              form this computer $orange


########################################################################################
" 
debug 3 "before choose"
choose "xpmq" ; read choice ; set_terminal
case $choice in Q|q|QUIT|Quit|quit) exit 0 ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 
m|M) back2main ;;
bc)
nano $HOME/.btcpayserver/Main/settings.config
continue
;;

nc)
nano $HOME/.nbxplorer/Main/settings.config
continue
;;

c|C|Connect|connect)
connect_btcpay_to_lnd
;;

start|START|Start)
start_btcpay
;;

stop|STOP|Stop)
stop_btcpay
;;

restart|Restart)
restart_btcpay
;;

log|Log|LOG)
set_terminal ; log_counter
if [[ $log_count -le 10 ]] ; then
echo "
########################################################################################
    
    This will show the BTCpay log file in real-time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
fi

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
