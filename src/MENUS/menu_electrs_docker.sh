function menu_electrs_docker {

while true ; do
set_terminal
source $dp/parmanode.conf >/dev/null 2>&1

if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then
    if sudo cat /etc/tor/torrc | grep -q "electrs" >/dev/null 2>&1 ; then
        if sudo cat /var/lib/tor/electrs-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        E_tor="${green}on${orange}"
        fi
    fi
else
E_tor="${red}off${orange}"
fi

electrs_version=$(docker exec -it electrs /home/parman/parmanode/electrs/target/release/electrs --version | tr -d '\r' 2>/dev/null )
set_terminal_custom 50
echo -e "
########################################################################################
                                ${cyan}Electrs Menu $electrs_version ${orange}
########################################################################################
"
if docker ps | grep -q electrs >/dev/null 2>&1 ; then echo -e "
                   ELECTRS IS$green RUNNING$orange -- SEE LOG MENU FOR PROGRESS 

                         Sync'ing to the $drive_electrs drive

      127.0.0.1:50005:t    or    127.0.0.1:50006:s    or    $IP:50006:s
"
else
echo -e "
                   ELECTRS IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

                         Will sync to the $drive_electrs drive"
fi
echo "


      (i)        Important info / Troubleshooting

      (start)    Start electrs 

      (stop)     Stop electrs 

      (r)        Restart electrs 

      (remote)   Choose which Bitcoin Core for electrs to connect to

      (c)        How to connect your Electrum wallet to electrs 
	    
      (log)      Inspect electrs logs

      (ec)       Inspect and edit config.toml file 

      (up)       Set/remove/change Bitcoin rpc user/pass (electrs config file updates)

      (dc)       electrs database corrupted? -- Use this to start fresh."

if [[ $OS == Linux ]] ; then echo -e "
      (tor)      Enable/Disable Tor connections to electrs -- Status : $E_tor"  ; else echo -e "
" 
fi
if grep -q "electrs_tor" < $HOME/.parmanode/parmanode.conf ; then 
get_onion_address_variable "electrs" >/dev/null ; echo -e "
    Onion adress:$bright_blue $ONION_ADDR_ELECTRS:7004 $orange


########################################################################################
"
else echo "
########################################################################################
"
fi
choose "xpmq" ; read choice ; set_terminal
case $choice in
m|M) back2main ;;
I|i|info|INFO)
info_electrs_docker
break
;;

start | START)
docker_start_electrs 
continue
;;

stop | STOP) 
docker_stop_electrs
continue
;;

r|R) 
docker_stop_electrs
docker_start_electrs
continue
;;

remote|REMOTE|Remote)
set_terminal
electrs_to_remote
docker_stop_electrs
docker_start_electrs
set_terminal
;;

c|C)
electrum_wallet_info
continue
;;

log|LOG|Log)

set_terminal ; log_counter
if [[ $log_count -le 15 ]] ; then
echo "
########################################################################################
    
    This will show the electrs log output in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
fi

    set_terminal_wider
    docker exec -it electrs /bin/bash -c "tail -f $HOME/.parmanode/run_electrs.log" &     
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
    continue

;;

ec|EC|Ec|eC)
echo "
########################################################################################
    
        This will run Nano text editor to edit config.toml. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart electrs.

########################################################################################
"
enter_continue
nano $HOME/.electrs/config.toml
 
continue
;;

up|UP|Up|uP)
set_rpc_authentication
continue
;;

p|P) menu_use ;; 

q|Q|Quit|QUIT)
exit 0
;;

tor|TOR|Tor)
if [[ $OS == Mac ]] ; then no_mac ; continue ; fi
if [[ $E_tor == off ]] ; then
electrs_tor
else
electrs_tor_remove
fi
;;

dc|DC|Dc)
electrs_database_corrupted 
;;

*)
invalid
;;
esac
done

return 0
}

function waif4bitcoin {

menu_bitcoin_status >/dev/null 2>&1
if ! echo $running_text | grep -q "fully"  ; then
announce "Bitcoin needs to be fully synced and running first"
return 1
fi

}


