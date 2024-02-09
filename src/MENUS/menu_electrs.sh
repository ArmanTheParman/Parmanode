function menu_electrs {
logfile=$HOME/.parmanode/run_electrs.log 

if grep -q "electrsdkr2" < $ic ; then
    electrsis=docker
    docker exec electrs cat /home/parman/run_electrs.log > $logfile
else
    electrsis=nondocker
    if [[ $OS == Linux ]] ; then
       journalctl -exu electrs.service > $logfile 
    elif [[ $OS == Mac ]] ; then
    # Background process is writing continuously to $logfile.
    true #do nothing, sturctured so for readability.
    fi
fi

while true ; do
unset log_size 

#no need to check log size only if log is from journalctl output, otherwise
#log file is growing from a process output with '>>'
if ! [[ $OS == Linux && $electrsis == nondocker ]] ; then 
log_size=$(ls -l $logfile | awk '{print $5}'| grep -oE [0-9]+)
log_size=$(echo $log_size | tr -d '\r\n')
fi
set_terminal

source $dp/parmanode.conf >/dev/null 2>&1
unset ONION_ADDR_ELECTRS E_tor E_tor_logic drive_electrselectrs_version electrs_sync 
menu_electrs_status # get elecyrs_sync variable (block number)

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc && $electrsis == nondocker ]] ; then
    if sudo cat /etc/tor/torrc | grep -q "electrs" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/electrs-service ]] && \
        sudo cat /var/lib/tor/electrs-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        E_tor="${green}on${orange}"
        E_tor_logic=on
        fi

        if grep -q "electrs_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
        get_onion_address_variable "electrs" >/dev/null 
        fi
    else
        E_tor="${red}off${orange}"
        E_tor_logic=off
    fi
fi

if [[ $electrsis == docker ]] ; then
        ONION_ADDR_ELECTRS=$(docker exec -u root electrs cat /var/lib/tor/electrs-service/hostname)
fi


#Get version
if [[ $electrsis == docker ]] ; then
    if docker exec electrs /home/parman/parmanode/electrs/target/release/electrs --version >/dev/null 2>&1 ; then
        electrs_version=$(docker exec electrs /home/parman/parmanode/electrs/target/release/electrs --version | tr -d '\r' 2>/dev/null )
        log_size=$(docker exec electrs /bin/bash -c "ls -l $logfile | awk '{print \$5}' | grep -oE [0-9]+" 2>/dev/null)
        log_size=$(echo $log_size | tr -d '\r\n')
        if docker exec -it electrs /bin/bash -c "tail -n 10 $logfile" | grep -q "electrs failed" ; then unset electrs_version 
        fi
    fi
else #electrsis nondocker
        electrs_version=$($HOME/parmanode/electrs/target/release/electrs --version >2/dev/null)
fi



debug "electrs_version is $electrs_version
log size is $log_size
electrsis is $electrsis
electrs_sync is $electrs_sync
"

set_terminal_custom 50

echo -e "
########################################################################################
                                ${cyan}Electrs $electrs_version Menu${orange} 
########################################################################################
"
if [[ -n $log_size && $log_size -gt 100000000 ]] ; then echo -e "$red
    THE LOG FILE SIZE IS GETTING BIG. TYPE 'logdel' AND <enter> TO CLEAR IT.
    $orange"
fi

if [[ $electrsis == nondocker ]] ; then
if ps -x | grep electrs | grep conf >/dev/null 2>&1  && ! tail -n 10 $logfile 2>/dev/null | grep -q "electrs failed"  ; then echo -e "
      ELECTRS IS:$green RUNNING$orange

      STATUS:     $green$electrs_sync$orange ($drive_electrs drive)

      CONNECT:$cyan    127.0.0.1:50005:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50006:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50006:s          $yellow \e[G\e[41G(From any home network computer)$orange
                  "
      if [[ -z $ONION_ADDR_ELECTRS ]] ; then
         echo -e "                  PLEASE WAIT A MOMENT AND REFRESH FOR ONION ADDRESS TO APPEAR"
      else
         echo -e "                 $bright_blue $ONION_ADDR_ELECTRS:7004:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange"
      fi
else #electrs running or not
echo -e "
      ELECTRS IS:$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

      Will sync to the $cyan$drive_electrs$orange drive"
fi #end electrs running or not

else #electrs is docker
if ! docker ps | grep -q electrs ; then echo -e "
$red $blinkon
                   DOCKER CONTAINER IS NOT RUNNING
$blinkoff$orange"
fi
if docker exec electrs bash -c "ps -x" 2>/dev/null | grep electrs | grep -q conf && ! tail -n 7 $logfile | grep -q 'electrs failed' ; then echo -e "
      ELECTRS IS:$green RUNNING$orange

      STATUS:     $green$electrs_sync$orange ($drive_electrs drive)

      CONNECT:$cyan    127.0.0.1:50005:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50006:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50006:s          $yellow \e[G\e[41G(From any home network computer)$orange
                  "
         echo -e "                 $bright_blue $ONION_ADDR_ELECTRS:7004:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange
         $bright_blue \e[G\e[23GFor Docker only, this computer has Tor in a container, port 9060 (not 9050)$orange"
else
echo -e "
                   ELECTRS IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

                   Will sync to the $cyan$drive_electrs$orange drive"
fi
fi #end electrsis docker
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

if [[ $OS == Linux && $electrsis == nondocker ]] ; then echo -e "
      (tor)      Enable/Disable Tor connections to electrs -- Status : $E_tor"  ; else echo -e "
" 
fi
echo -e "
########################################################################################
"

choose "xpmq"
echo -e "$red
 Hit 'r' to refresh menu 
 $orange"
read choice ; set_terminal

case $choice in
m|M) back2main ;;
r) menu_electrs || return 1 ;;

I|i|info|INFO)
if [[ $electrsis == docker ]] ; then 
info_electrs_docker
else
info_electrs
fi
break
;;

start | START)
if [[ $electrsis == docker ]] ; then 
docker_start_electrs
else
start_electrs 
sleep 1
fi
;;

stop | STOP) 
if [[ $electrsis == docker ]] ; then 
docker_stop_electrs
else
stop_electrs
fi
;;

logdel)
please_wait
if [[ $electrsis == docker ]] ; then
docker_stop_electrs #stops electrs container
docker start electrs >/dev/null 2>&1 #starts container
docker exec electrs bash -c "rm $logfile"
docker_start_electrs #starts electrs inside running container
else
stop_electrs
rm $logfile
start_electrs
fi
;;

restart|Restart)
if [[ $electrsis == docker ]] ; then
docker_stop_electrs
docker_start_electrs
else
restart_electrs
sleep 2
fi
;;

remote|REMOTE|Remote)
if [[ $electrsis == docker ]] ; then
set_terminal
electrs_to_remote
docker_stop_electrs
docker_start_electrs
set_terminal
else
set_terminal
electrs_to_remote
restart_electrs
set_terminal
fi
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
if [[ $electrsis == docker ]] ; then 
    set_terminal_wider
    docker exec -it electrs /bin/bash -c "tail -f /home/parman/run_electrs.log"      
        # tail_PID=$!
        # trap 'kill $tail_PID' SIGINT #condition added to memory
        # wait $tail_PID # code waits here for user to control-c
        # trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
 
 else

if [[ $OS == Mac ]] ; then
    set_terminal_wider
    tail -f $logfile &     
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
fi

if [[ $OS == "Linux" ]] ; then
    set_terminal_wider
    journalctl -fexu electrs.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
    menu_electrs #this is so the status refreshes 
fi
fi # end electrsis
menu_electrs #this is so the status refreshes 
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
if [[ $E_tor_logic == off || -z $E_tor_logic ]] ; then
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


function menu_electrs_status {
please_wait

if ! which jq >/dev/null 2>&1 ; then
export electrs_sync="PLEASE INSTALL JQ FOR THIS TO WORK"
return 0
fi

#get bitcoin block number
source $bc
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/ >/tmp/result 2>&1
gbci=$(cat /tmp/result | grep -E ^{ | jq '.result')

#bitcoin finished?
bsync=$(echo $gbci | jq -r ".initialblockdownload") #true or false

if [[ $bsync == true ]] ; then

    export electrs_sync="Bitcoin still sync'ing"

elif [[ $bsync == false ]] ; then
    #fetches block number...
    export electrs_sync=$(tail -n5 $logfile | grep height | tail -n 1 | grep -Eo 'height.+$' | cut -d = -f 2 | tr -d '[[:space:]]') >/dev/null
debug2 "electrs_sync is $electrs_sync"
    #in case an unexpected non-number string, printout, otherwise check if full synced.
    if ! echo $electrs_sync | grep -qE '^[0-9]+$' >/dev/null ; then

        debug "electrs sync: $electrs_sync, line 361" 
        export electrs_sync="Wait...$orange"

    else 
        debug "electrs sync: $electrs_sync, line 3365" 
        bblock=$(echo $gbci | jq -r ".blocks")    

        if [[ $bblock == $electrs_sync ]] ; then
        export electrs_sync="Block $electrs_sync ${pink}Fully sync'd$orange"
        else
        export electrs_sync="Up to $electrs_sync $orange, sync'ing to block $bblock" 
        fi 
    fi

    if [[ -z $electrs_sync ]] ; then
        export electrs_sync="Wait...$orange"
    fi
fi
}