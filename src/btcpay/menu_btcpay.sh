function menu_btcpay {
while true ; do

menu_bitcoin menu_btcpay #gets variables output1 

if echo $output1 | grep -q "choose" ; then
output1a=$(echo "$output1" | sed 's/start/sb/g') #choose start to run changed to choose sb to run. Option text comes from another menu.
else
output1a="$output1"
fi

set_terminal_custom 51 
unset menu_tor enable_tor_menu tor_on findbtcp

if which tor >/dev/null && [[ $OS == Linux ]] ; then 
get_onion_address_variable btcpay 
menu_tor="    TOR: $bright_blue
        http://$ONION_ADDR_BTCPAY:7003$orange
        "
fi

findbtcp=$(sudo find /var/lib/tor/ -name 'btcp*' 2>/dev/null) >/dev/null 2>&1 || unset findbtcp

if which tor >/dev/null && [[ -z $findbtcp ]] && [[ $OS != Mac ]] ; then
enable_tor_menu="$bright_blue             tor)          Enable Tor$orange"
unset menu_tor
fi
clear
echo -en "
########################################################################################
                                 ${cyan}BTCPay Server Menu${orange}
########################################################################################


"
if docker ps 2>/dev/null | grep -q btcp >/dev/null 2>&1 ; then echo -e "
                  BTCPay SERVER IS$green RUNNING$orange -- SEE LOG MENU FOR PROGRESS "
else
echo -e "
                  BTCPay SERVER IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi

echo -ne "
$output1a" 

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

             sb)           Start Bitcoin

             stp)          Stop Bitcoin

$enable_tor_menu

    To access:     

        http://${IP}:23001$yellow           
        from any computer on home network    $orange

        http://localhost:23001$yellow       
        from this computer $orange

$menu_tor

########################################################################################
" 
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
start_btcpay_all_programs
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
echo -e "
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
continue 
;;

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

tor)
if [[ -n $enable_tor_menu ]] ; then
enable_tor_btcpay
success "BTC Pay over Tor enabled"
continue
fi
;;

sb)
start_bitcoind
;;

stp)
stop_bitcoind
;;

*)
invalid ;;
esac  

done
return 0
}
