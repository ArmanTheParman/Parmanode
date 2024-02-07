function menu_fulcrum {
unset refresh
while true
do
get_fulcrum_status
set_terminal

if [[ $OS == Linux ]] ; then
if sudo cat /etc/tor/torrc | grep -q "fulcrum" >/dev/null 2>&1 ; then
    if sudo cat /var/lib/tor/fulcrum-service/hostname | grep -q "onion" >/dev/null 2>&1 ; then
    F_tor="on"
    fi
else
    F_tor="off"
fi
fi

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
#menu_bitcoin_status #fetches block height quicker than getblockchaininfo
unset fulcrum_status fulcrum_sync 
if [[ ! $refresh == true ]] ; then
fulcrum_status="...Type r to refresh"
fulcrum_sync="...Type r to refresh"
else
menu_fulcrum_status
fi

set_terminal_custom 45
echo -e "
########################################################################################
                                   ${cyan}Fulcrum Menu${orange}                               
########################################################################################
"
if [[ $OS == "Linux" ]] ; then
if ps -x | grep fulcrum | grep conf >/dev/null 2>&1 ; then echo -e "
                   FULCRUM IS$green RUNNING$orange - STATUS: $status 

                            Status: $fulcrum_status
                            Block : $fulcrum_sync  $reset
                            Syncing to the $drive_fulcrum drive$orange"
else
echo -e "$orange
                   FULCRUM IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi #end if ps -x
fi #end if Linux
if [[ $OS == "Mac" ]] ; then
if docker ps 2>/dev/null | grep -q fulcrum && docker exec -it fulcrum bash -c "pgrep Fulcrum" >/dev/null 2>&1 ; then echo -e "
                   FULCRUM IS RUNNING -- SEE LOG MENU FOR PROGRESS

                            Status: $fulcrum_status
                            Block : $fulcrum_sync  $reset   
                            Syncing to the $drive_fulcrum drive$orange"
else
echo -e "
                   FULCRUM IS NOT RUNNING -- CHOOSE \"start\" TO RUN" 
fi
fi

echo -e "


      (start)    Start Fulcrum 

      (stop)     Stop Fulcrum 

      (restart)  Restart Fulcrum

      (c)        How to connect your Electrum wallet to Fulcrum

      (log)      Inspect Fulcrum logs

      (fc)       Inspect and edit fulcrum.conf file 

      (up)       Set/remove/change Bitcoin rpc user/pass (Fulcrum config file updates)
    
      (remote)   Connect this Fulcrum server to Bitcoin Core on a different computer
    
      (tor)      Enable Tor connections to Fulcrum -- Fulcrum Tor Status : $F_tor

      (torx)     Disable Tor connection to Fulcrum -- Fulcrum Tor Status : $F_tor

      (dc)       Fulcrum database corrupted? -- Use this to start fresh.
"
if grep -q "fulcrum_tor" < $HOME/.parmanode/parmanode.conf ; then 
get_onion_address_variable "fulcrum" >/dev/null ; echo -e "
$bright_blue    Onion adress: $ONION_ADDR_FULCRUM:7002 $orange

########################################################################################
"
else echo -e "########################################################################################
"
fi
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;
r) please_wait ; menu_fulcrum_status ; refresh=true ;;

start | START)
check_fulcrum_pass
set_terminal
echo "Fulcrum starting..."
if [[ $OS == "Linux" ]] ; then start_fulcrum_linux ; fi
if [[ $OS == "Mac" ]] ; then start_fulcrum_docker ; fi 
set_terminal
;;

stop | STOP) 
set_terminal
echo "Stopping Fulcrum ..."
if [[ $OS == "Linux" ]] ; then stop_fulcrum_linux ; fi
if [[ $OS == "Mac" ]] ; then  stop_fulcrum_docker ; fi
set_terminal
;;

# bitcoin|Bitcoin)
# set_terminal
# bitcoin_core_choice_fulcrum
# set_terminal
# ;;

restart|Rrestart) 
if [[ $OS == "Linux" ]] ; then 
    sudo systemctl restart fulcrum.service
    fi
if [[ $OS == "Mac" ]] ; then
    stop_fulcrum_docker
    start_fulcrum_docker
    fi
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
if [[ $OS == "Linux" ]] ; then
    set_terminal_wider
    journalctl -fexu fulcrum.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the trap so control-c works elsewhere.
    set_terminal
fi
if [[ $OS == "Mac" ]] ; then
    set_terminal_wider
    docker exec -it fulcrum tail -f /home/parman/parmanode/fulcrum/fulcrum.log 
    echo ""
    set_terminal
fi
continue ;;

fc|FC|Fc|fC)
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	    Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
fi

if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	    Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
fi

continue
;;

up|UP|Up|uP)
set_rpc_authentication
continue
;;

p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

q|Q|Quit|QUIT)
exit 0
;;

Remote|REMOTE|remote)
if [[ $OS == "Mac" ]] ; then fulcrum_to_remote ; fi
if [[ $OS == "Linux" ]] ; then echo "" ; echo "Only available for Mac, for now." 
enter_continue
fi
;;

tor|TOR|Tor)
fulcrum_tor
;;

torx|TORX|Torx)
fulcrum_tor_remove
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
local file="/tmp/fulcrum.journal"

if [[ $OS == Mac ]] ; then
    if docker ps >/dev/null ; then
        docker exec -it fulcrum /bin/bash -c "cat /home/parman/parmanode/fulcrum/fulcrum.log" > $file 2>&1
    else
       echo "Docker not running." > $file 
    fi
else
journalctl -exu fulcrum.service > $file 2>&1
fi

if tail -n1 $file | grep -q 'Processed height:' ; then
export fulcrum_status=syncing
#fetches block number...
export fulcrum_sync=$(journalctl -exu fulcrum.service | tail -n1 $file | grep Processed | grep blocks/ | grep addrs/ \
| grep -Eo 'Processed height:.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
rm $file
return 0
fi

if tail -n20 /tmp/fulcrum.journal | grep -q "up-to-date" ; then
export fulcrum_status=up-to-date
#fetches block number...
export fulcrum_sync=$(tail -n20 /tmp/fulcrum.journal | grep "up-to-date" | \
tail -n1 | grep -Eo 'Block height.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
rm $file
return 0
fi

fulcrum_status="See log for info"
fulcrum_sync="?"
rm $file
return 0
}

function get_fulcrum_status {
#example string to search in...
#Feb 07 16:39:55 parman Fulcrum[3507595]: [2024-02-07 16:39:55.650] <Controller> Processed height: 370000, 44.6%, 2.03 blocks/sec, 1532.1 txs/sec, 6126.9 addrs/sec

if [[ $OS == Linux ]] ; then
journalctl -fexu fulcrum.service > /tmp/fulcrum_status 
elif [[ $OS == Mac ]] ; then
docker exec fulcrum cat /home/parman/parmanode/fulcrum/fulcrum.log > /tmp/fulcrum_status 
fi

status="$(tail -n 5 /tmp/fulcrum_status | grep "<Controller>" | grep "Processed height:" | grep "blocks/sec")"

export status="$(echo $status | cut -d % -f 1 | grep -Eo '.{9}$' | cut -d , -f 2 | tr -d '[[:space:]]')"

if [[ -z $status ]] ; then
export status="check logs"
else
export status="${status}%"
fi

}

