function menu_electrs_docker {


logfile="/home/parman/run_electrs.log"




set_terminal_custom 50
debug "electrs version, $electrs_version"

echo -e "
########################################################################################
                                ${cyan}Electrs Menu $electrs_version ${orange}
########################################################################################
"
if [[ $log_size -gt 100000000 ]] ; then echo -e "$red
    THE LOG FILE SIZE IS GETTING BIG. TYPE 'logdel' AND <enter> TO CLEAR IT.
    $orange"
fi

echo "


      (i)        Important info / Troubleshooting

      (start)    Start electrs 

      (stop)     Stop electrs 

      (restart)  Restart electrs 

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

logdel)
please_wait
docker_stop_electrs
docker start electrs >/dev/null 2>&1
docker exec -it electrs bash -c "rm $logfile"
docker_start_electrs
;;

restart|Restart)
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
    docker exec -it electrs /bin/bash -c "tail -f $logfile"      
        # tail_PID=$!
        # trap 'kill $tail_PID' SIGINT #condition added to memory
        # wait $tail_PID # code waits here for user to control-c
        # trap - SIGINT # reset the t. rap so control-c works elsewhere.
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

tor|TOR|Tor)
if [[ $OS == Mac ]] ; then no_mac ; continue ; fi
if [[ $E_tor_logic == off ]] ; then
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


