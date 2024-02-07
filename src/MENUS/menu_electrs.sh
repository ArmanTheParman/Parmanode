function menu_electrs {

logfile=$HOME/.parmanode/run_electrs.log

while true ; do
unset log_size electrs_sync

log_size=$(ls -l $logfile | awk '{print $5}'| grep -oE [0-9]+)
log_size=$(echo $log_size | tr -d '\r\n')

set_terminal

source $dp/parmanode.conf >/dev/null 2>&1
unset ONION_ADDR_ELECTRS E_tor E_tor_logic drive_electrselectrs_version electrs_sync 
menu_electrs_status

if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then
    if sudo cat /etc/tor/torrc | grep -q "electrs" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/electrs-service ]] && \
        sudo cat /var/lib/tor/electrs-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        E_tor="${green}on${orange}"
        E_tor_logic=on
        fi
    else
        E_tor="${red}off${orange}"
        E_tor_logic=off
    fi
fi

electrs_version=$($HOME/parmanode/electrs/target/release/electrs --version >2/dev/null)
set_terminal_custom 50

echo -e "
########################################################################################
                                ${cyan}Electrs $electrs_version Menu${orange} 
########################################################################################
"
if [[ $log_size -gt 100000000 ]] ; then echo -e "$red
    THE LOG FILE SIZE IS GETTING BIG. TYPE 'logdel' AND <enter> TO CLEAR IT.
    $orange"
fi
if ps -x | grep electrs | grep conf >/dev/null 2>&1  && ! tail -n 10 $logfile 2>/dev/null | grep -q "electrs failed"  ; then echo -e "
                   ELECTRS IS$green RUNNING$orange -- SEE LOG MENU FOR PROGRESS 

                         Sync'ing to the $drive_electrs drive
                         STATUS:$green $electrs_sync

      127.0.0.1:50005:t    or    127.0.0.1:50006:s    or    $IP:50006:s
$bright_blue      127 IP from this computer only$orange
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
if grep -q "electrs_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
get_onion_address_variable "electrs" >/dev/null 
if [[ -z $ONION_ADDR_ELECTRS ]] ; then
echo -e "$bright_blue
    Please wait then refresh for onion address$orange


########################################################################################
"
else
echo -e "
    Onion adress:$bright_blue $ONION_ADDR_ELECTRS:7004 $orange


########################################################################################
"
fi #end if no onion address
else echo "
########################################################################################
"
fi #end if tor is true

choose "xpmq"
echo -e "$red
 Hit 'r' to refresh menu 
 $orange"
read choice ; set_terminal

case $choice in
m|M) back2main ;;
r) menu_electrs || return 1 ;;

I|i|info|INFO)
info_electrs
break
;;

start | START)
start_electrs 
sleep 1
;;

stop | STOP) 
stop_electrs
continue
;;

logdel)
please_wait
stop_electrs
rm $logfile
start_electrs
;;

restart|Restart)
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
    tail -f $logfile &     
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

p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

q|Q|Quit|QUIT)
exit 0
;;

tor|TOR|Tor)
debug "line 215, before ifs"
if [[ $OS == Mac ]] ; then no_mac ; continue ; fi
if [[ $E_tor_logic == off || -z $E_tor_logic ]] ; then
electrs_tor
debug "line 219, menu, in E_tor_logic"
else
debug "line 221, before electrs_tor_remove"
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


function menu_electrs_status {

if ! which jq >/dev/null 2>&1 ; then
export electrs_sync="PLEASE INSTALL JQ FOR THIS TO WORK"
return 0
fi

#get bitcoin block number
gbci=$(bitcoin-cli getblockchaininfo)

#bitcoin finished?
bsync=$(echo $gbci | jq -r ".initialblockdownload") #true or false

if [[ $bsync == true ]] ; then

    export electrs_sync="Bitcoin still sync'ing"

elif [[ $bsync == false ]] ; then

    #fetches block number...
    export electrs_sync=$(tail -n5 $logfile | grep height | tail -n 1 | grep -Eo 'height.+$' | cut -d = -f 2 | tr -d '[[:space:]]')

    #in case an unexpected non-number string
    if ! echo $electrs_sync | grep -E '^[0-9]+$' ; then
    echo "electrs sync: $electrs_sync" | tee -a $dp/electrs.log 
    export electrs_sync="SEE LOGS"
    fi

fi
}