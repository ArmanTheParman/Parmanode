function menu_fulcrum {

while true ; do
set_terminal

isbitcoinrunning
if [[ $bitcoinrunning == "true" ]] ; then
unset isbitcoinrunning_fulcrum
else
isbitcoinrunning_fulcrum="${red}${blinkon}Bitcoin is NOT running${blinkoff}$orange"
fi

if    sudo cat $macprefix/etc/tor/torrc 2>$dn | grep -q "fulcrum" >$dn 2>&1 \
   && sudo cat $macprefix/var/lib/tor/fulcrum-service/hostname | grep -q "onion" >$dn 2>&1 ; then

    F_tor="${green}on$orange"
    f_tor="on" 

else
    F_tor="${red}off$orange"
    f_tor="off"
fi

source $pc >$dn 2>&1
#bitcoin_status #fetches block height quicker than getblockchaininfo
unset fulcrum_status fulcrum_sync 
menu_fulcrum_status
fulcrum_message="${blinkon}Type$red r$orange to refresh${blinkoff}$orange"

#if grep -q "fulcrum-" $ic ; then
#    if ps -x | grep fulcrum | grep conf >$dn 2>&1 ; then echo -en "
isfulcrumrunning ; source $oc >/dev/null 2>&1


set_terminal_custom 47
echo -e "
########################################################################################
                                   ${cyan}Fulcrum Menu${orange}                               
########################################################################################"
if [[ $fulcrumrunning == "true" ]] ; then echo -en "
      FULCRUM IS :$green   RUNNING$orange $isbitcoinrunning_fulcrum 
      STATUS     :   $fulcrum_status
      BLOCK      :   $fulcrum_sync $fulcrum_message
      DRIVE      :   $drive_fulcrum $orange


      CONNECT  $cyan    127.0.0.1:50001:t    $yellow (From this computer only)$orange
               $cyan    127.0.0.1:50002:s    $yellow (From this computer only)$orange 
               $cyan    $IP:50002:s          $yellow \e[G\e[42G(From any home network computer)$orange
                  "
   else
echo -en "$orange
                   $isbitcoinrunning_fulcrum 
                   FULCRUM IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi
echo -e "
$green
      (start)   $orange Start Fulcrum 
$red
      (stop)  $orange   Stop Fulcrum 
$cyan
      (restart)$orange  Restart Fulcrum
$cyan
      (c)$orange        How to connect your Electrum wallet to Fulcrum
$cyan
      (log)$orange      Inspect Fulcrum logs
$cyan
      (fc)$orange       Inspect and edit fulcrum.conf file (fcv for vim)
$cyan
      (tor)$orange      Toggle Tor connections to Fulcrum -- Fulcrum Tor Status : $F_tor
$cyan
      (man)$orange      Manually explore the docker container
$cyan    
      (dc)$orange       Fulcrum database corrupted? -- Use this to start fresh.
"
if grep -q "fulcrum_tor" < $HOME/.parmanode/parmanode.conf ; then 
get_onion_address_variable "fulcrum"
echo -e "
$bright_blue    Onion adress: $ONION_ADDR_FULCRUM:7002 $orange

########################################################################################
"
else echo -e "########################################################################################
"
fi
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;
r) please_wait ; menu_fulcrum_status ;; 

start | START)
set_terminal
echo "Fulcrum starting..."
start_fulcrum 
set_terminal
;;

stop | STOP) 
set_terminal
echo "Stopping Fulcrum ..."
stop_fulcrum 
set_terminal
;;

restart|Rrestart) 
    stop_fulcrum
    start_fulcrum
;;

c|C)
electrum_wallet_info
continue
;;

log|LOG|Log)
set_terminal
log_counter
if [[ $log_count -le 20 ]] ; then
echo -e "
########################################################################################
    
    This will show the fulcrum log output in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi
if grep -q "fulcrum-" $ic ; then
    set_terminal_wider
    sudo journalctl -fexu fulcrum.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT EXIT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the trap so control-c works elsewhere.
    set_terminal
else
    set_terminal_wider
    docker exec -it fulcrum tail -f /home/parman/parmanode/fulcrum/fulcrum.log 
    echo ""
    set_terminal
fi
continue 
;;

fc|FC|Fc|fC)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit.$red Be careful messing around with this file. $orange

        Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
sudo nano $fc
;;

fcv)
vim_warning 
sudo vim $fc
;;

man)
yesorno "Do you want to log in as the root user or parman (sudo password: parmanode)" "r" "root" "pp" "parman" \
         && {
            clear
            docker exec -itu root fulcrum bash
            continue
         }
         clear
         docker exec -itu parman fulcrum bash
         ;;

p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

q|Q|Quit|QUIT)
exit 0
;;

tor|TOR|Tor)
if [[ $f_tor == "off" ]] ; then
fulcrum_tor
else
fulcrum_tor_remove
fi
;;

dc|DC|Dc|dC)
fulcrum_database_corrupted
;;

*)
invalid
;;
esac
done

return 0
}


function menu_fulcrum_status {
local file="$tmp/fulcrum.journal"

if grep -q "fulcrumdkr" $ic ; then
    if docker ps >$dn ; then
       docker exec -it fulcrum /bin/bash -c "cat /home/parman/parmanode/fulcrum/fulcrum.log" > $file 2>&1
    else
       echo "Docker not running." > $file 
    fi
else
sudo journalctl -exu fulcrum.service > $file 2>&1
fi

if tail -n1 $file | grep -q 'Processed height:' ; then
export fulcrum_status=syncing
#fetches block number...
export fulcrum_sync=$(sudo journalctl -exu fulcrum.service | tail -n1 $file | grep Processed | grep blocks/ | grep addrs/ \
| grep -Eo 'Processed height:.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
rm $file
return 0
fi

if tail -n20 $tmp/fulcrum.journal | grep -q "up-to-date" ; then
export fulcrum_status=up-to-date
#fetches block number...
export fulcrum_sync=$(tail -n20 $tmp/fulcrum.journal | grep "up-to-date" | \
tail -n1 | grep -Eo 'Block height.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
rm $file
return 0
fi

fulcrum_status="See log for info"
fulcrum_sync="?"
rm $file
return 0
}

