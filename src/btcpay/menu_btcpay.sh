function menu_btcpay {
while true ; do

menu_bitcoin menu_btcpay #gets variables output1 for menu text

if echo $output1 | grep -q "choose" ; then
output2=$(echo "$output1" | sed 's/start/sb/g') #choose start to run changed to choose sb to run. Option text comes from another menu.
else
output2="$output1"
fi

set_terminal_custom 51 
unset menu_tor enable_tor_menu tor_on 

if sudo cat $macprefix/var/lib/tor/btcpay-service/hostname 2>$dn | grep -q "onion" \
   && sudo grep -q "7003" $macprefix/etc/torrc \
   && sudo grep -q "btcpay-service" $macprefix/etc/torrc ; then 

    get_onion_address_variable btcpay 
    menu_tor="    TOR: $bright_blue
        http://$ONION_ADDR_BTCPAY:7003$orange
        "
else
    enable_tor_menu="$bright_blue             tor)          Enable Tor$orange"
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
$output2" 

echo -e "

$cyan
             pp)$orange           BTC ParmanPay - Online payment app, worldwide access
$cyan
             start)$orange        Start BTCPay (starts Docker container)
$cyan
             stop)$orange         Stop BTCPay (stops Docker container)
$cyan
             restart)$orange      Restart BTCPay (restarts Docker container)
$cyan
             c)$orange            Connect BTCPay to LND
$cyan
             bc)$orange           BTCPay config file (bcv for vim)
$cyan
             nc)$orange           NBXplorer config file (ncv for vim)
$cyan
             log)$orange          View BTCPay Server log
$cyan
             nl)$orange           View NBXplorer log
$cyan
             sb)$orange           Start Bitcoin
$cyan
             stp)$orange          Stop Bitcoin

$enable_tor_menu

    For access:     

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
bcv)
vim_warning ; vim $HOME/.btcpayserver/Main/settings.config
continue
;;

nc)
nano $HOME/.nbxplorer/Main/settings.config
continue
;;
ncv)
vim_warning ; vim $HOME/.nbxplorer/Main/settings.config
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
