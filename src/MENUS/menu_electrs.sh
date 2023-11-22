function menu_electrs {

while true ; do
set_terminal
source $dp/parmanode.conf >/dev/null 2>&1

if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then
    if sudo cat /etc/tor/torrc | grep -q "electrs" >/dev/null 2>&1 ; then
        if sudo cat /var/lib/tor/electrs-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        E_tor="${green}on${orange}"
        E_tor_logic=on
        fi
    else
        E_tor="${red}off${orange}"
        debug "in else $E_tor"
        E_tor_logic=off
    fi
fi
debug "etor is $E_tor"
electrs_version=$($HOME/parmanode/electrs/target/release/electrs --version)
set_terminal_custom 50
echo -e "
########################################################################################
                                ${cyan}Electrs $electrs_version Menu${orange} 
########################################################################################
"
if ps -x | grep electrs | grep conf >/dev/null 2>&1 ; then echo -e "
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
if grep -q "electrs_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
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
info_electrs
break
;;

start | START)
start_electrs 
sleep 2
;;

stop | STOP) 
stop_electrs
continue
;;

r|R) 
restart_electrs
sleep 2
continue
;;

remote|REMOTE|Remote)
set_terminal
electrs_to_remote
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

if [[ $OS == Mac ]] ; then
    set_terminal_wider
    tail -f $HOME/.parmanode/run_electrs.log &     
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
    continue
fi

if [[ $OS == "Linux" ]] ; then
    set_terminal_wider
    journalctl -fexu electrs.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
    continue
fi
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

function waif4bitcoin {

menu_bitcoin_core_status >/dev/null 2>&1
if ! echo $running_text | grep -q "fully"  ; then
announce "Bitcoin needs to be fully synced and running first"
return 1
fi

}


