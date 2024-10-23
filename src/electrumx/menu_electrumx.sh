function menu_electrumx {
#code template for docker version and Mac version entered but not yet functional
unset refresh
logfile=$HOME/.parmanode/run_electrumx.log 

if grep -q "electrumxdkr" < $ic ; then
    electrumxis=docker
    docker exec electrumx cat /home/parman/run_electrumx.log > $logfile
else
    electrumxis=nondocker
    if [[ $OS == Linux ]] ; then
       #-fexu will be used for log, but still need to get a log file snapshot
       sudo journalctl -exu electrumx.service > $logfile 2>&1
    elif [[ $OS == Mac ]] ; then
    # Background process is writing continuously to $logfile.
    true #do nothing, sturctured so for readability.
    fi
fi
while true ; do
unset log_size 

#no need to check log size only if log is from journalctl output, otherwise
#log file is growing from a process output with '>>'
if ! [[ $OS == Linux && $electrumxis == nondocker ]] ; then 
log_size=$(ls -l $logfile | awk '{print $5}'| grep -oE [0-9]+)
log_size=$(echo $log_size | tr -d '\r\n')
fi
set_terminal

#is electrumx running variable
unset running runningd
if [[ $electrumxis == nondocker ]] ; then
    if ps -x | grep electrumx | grep -v grep >/dev/null 2>&1  && ! tail -n 10 $logfile 2>/dev/null | grep -q "electrumx failed"  ; then 
    runningd=nondocker
    running="true"
    else
    runningd=falsenondocker
    running="false"
    fi
else 
    if ! docker ps | grep -q electrumx ; then
    runningd=docker
    running="true"
    else
    runningd=falsedocker
    running="false"
    fi
fi

unset ONION_ADDR_ELECTRUMX E_tor E_tor_logic drive_electrumx electrumx_version electrumx_sync 
source $dp/parmanode.conf >/dev/null 2>&1

if [[ $refresh == "true" ]] ; then
    if [[ $running == "true" ]] ; then 
        menu_electrumx_status # get elecyrs_sync variable (block number)
    fi
else
    electrumx_sync="${blinkon}${orange}Type$red r$orange to refresh${blinkoff}$orange"
fi

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc && $electrumxis == nondocker ]] ; then
debug "in tor status"
    if sudo cat /etc/tor/torrc | grep -q "electrumx" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/electrumx-service ]] && \
        sudo cat /var/lib/tor/electrumx-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        E_tor="${green}on${orange}"
        E_tor_logic=on
        else
        E_tor="${yellow}wait${orange}"
        E_tor_logic=on
        fi
debug "in if cat torrc grep electrumx"
        if grep -q "electrumx_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
        get_onion_address_variable "electrumx" 
        fi
    else
        E_tor="${red}off${orange}"
        E_tor_logic=off
    fi
fi

if [[ $electrumxis == docker ]] ; then
        ONION_ADDR_ELECTRUMX=$(docker exec -u root electrumx cat /var/lib/tor/electrumx-service/hostname)
fi

debug "before get version"
#Get version
if [[ $electrumxis == docker ]] ; then
        electrumx_version=$(docker exec electrumx /bin/bash -c "grep -Eo 'software version: ElectrumX.+$' < $logfile | tail -n1 | grep -Eo [0-1].+$ | tr -d '[[:space:]]'")
        log_size=$(docker exec electrumx /bin/bash -c "ls -l $logfile | awk '{print \$5}' | grep -oE [0-9]+" 2>/dev/null)
        log_size=$(echo $log_size | tr -d '\r\n')
        if docker exec -it electrumx /bin/bash -c "tail -n 10 $logfile" | grep -q "electrumx failed" ; then unset electrumx_version 
        fi
else #electrumxis nondocker
        electrumx_version=$(grep -Eo 'software version: ElectrumX.+$' < $logfile | tail -n1 | grep -Eo [0-1].+$ | tr -d '[[:space:]]' )
fi
debug "before next clear"
set_terminal_custom 50

echo -en "
########################################################################################
                                ${cyan}Electrum X $electrumx_version Menu${orange} 
########################################################################################
"
if [[ -n $log_size && $log_size -gt 100000000 ]] ; then echo -e "$red
    THE LOG FILE SIZE IS GETTING BIG. TYPE 'logdel' AND <enter> TO CLEAR IT.
    $orange"
fi

if [[ $electrumxis == nondocker && $running == "true" ]] ; then
echo -en "
      ELECTRUM X IS:$green RUNNING$orange

      STATUS:     $green$electrumx_sync$orange ($drive_electrumx drive)

      CONNECT:$cyan    127.0.0.1:50007:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50008:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50008:s          $yellow \e[G\e[41G(From any home network computer)$orange

                                            $yellow \e[G\e[41G(Electrum X must finish sync before connecting)$orange"
      if [[ -z $ONION_ADDR_ELECTRUMX ]] ; then
         echo -en "                  PLEASE WAIT A MOMENT AND REFRESH FOR ONION ADDRESS TO APPEAR"
      else
         echo -en "
      TOR:$bright_blue 
                  $ONION_ADDR_ELECTRUMX:7006:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange"
      fi
elif [[ $electrumxis == nondocker && $running == "false" ]] ; then
echo -en "
      ELECTRUMX IS:$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

      Will sync to the $cyan$drive_electrumx$orange drive"
fi #end electrumx running or not

if [[ $electrumxis == docker ]] ; then

if ! docker ps | grep -q electrumx ; then echo -e "
$red $blinkon
                   DOCKER CONTAINER IS NOT RUNNING
$blinkoff$orange"
fi
if [[ $running == "true" ]] ; then echo -en "
      ELECTRUMX IS:$green RUNNING$orange

      STATUS:     $green$electrumx_sync$orange ($drive_electrumx drive)

      CONNECT:$cyan    127.0.0.1:50007:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50008:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50008:s          $yellow \e[G\e[41G(From any home network computer)$orange

                                            $yellow \e[G\e[41G(Electrum X must finish sync before connecting)$orange

      DOCKER TOR ONLY:
                 $bright_blue $ONION_ADDR_ELECTRUMX:7006:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange      " 

else
echo -en "
                   ELECTRUMX IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

                   Will sync to the $cyan$drive_electrumx$orange drive"
fi
fi #end electrumxis docker
echo -en "

$green
      (start)$orange    Start Electrum X 
$red
      (stop)$orange     Stop Electrum X

      (restart)  Restart Electrum X

      (remote)   Choose which Bitcoin Core for Electrum X to connect to

      (log)      Inspect Electrum X logs

      (ec)       Inspect and edit config file (ecv for vim)

      (dc)       Electrum X database corrupted? -- Use this to start fresh."

if [[ $OS == Linux && $electrumxis == nondocker ]] ; then echo -e "

      (tor)      Enable/Disable Tor connections to Electrum X -- Status : $E_tor"  ; else echo -e "

      (newtor)   Refresh Tor address
" 
fi
echo -e "
########################################################################################
"

choose "xpmq"
echo -e "$red$blinkon
 Hit 'r' to refresh menu $blinkoff
 $orange"
read choice ; set_terminal

case $choice in
m|M) back2main ;;

r) 
please_wait
refresh="true"
menu_electrumx || return 1 
;;

start | START)
if [[ $electrumxis == docker ]] ; then 
docker_start_electrumx
else
start_electrumx 
sleep 1
fi
;;

stop | STOP) 
if [[ $electrumxis == docker ]] ; then 
docker_stop_electrumx
else
stop_electrumx
fi
;;

logdel)
please_wait
if [[ $electrumxis == docker ]] ; then
docker_stop_electrumx #stops electrumx container
docker start electrumx >/dev/null 2>&1 #starts container
docker exec electrumx bash -c "rm $logfile"
docker_start_electrumx #starts electrumx inside running container
else
stop_electrumx
rm $logfile
start_electrumx
fi
;;

restart|Restart)
if [[ $electrumxis == docker ]] ; then
docker_stop_electrumx
docker_start_electrumx
else
restart_electrumx
sleep 2
fi
;;

remote|REMOTE|Remote)
if [[ $electrumxis == docker ]] ; then
set_terminal
electrumx_to_remote
docker_stop_electrumx
docker_start_electrumx
set_terminal
else
set_terminal
electrumx_to_remote
restart_electrumx
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
    
    This will show the Electrum X log output in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
fi
if [[ $electrumxis == docker ]] ; then 
    set_terminal_wider
    docker exec -it electrumx /bin/bash -c "tail -f /home/parman/run_electrumx.log"      
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
    sudo journalctl -fexu electrumx.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
    menu_electrumx #this is so the status refreshes 
fi
fi # end electrumxis
menu_electrumx #this is so the status refreshes 
;;

ec|EC|Ec|eC)
echo "
########################################################################################
    
        This will run Nano text editor to edit electrumx.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart Electrum X.

########################################################################################
"
enter_continue
nano $hp/electrumx/electrumx.conf
;;
ecv|ECV)
vim $hp/electrumx/electrumx.conf
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
electrumx_tor
else
electrumx_tor_remove
fi
;;

newtor)
sudo rm -rf /var/lib/tor/electrumx-service
sudo systemctl restart tor
announce "You need to wait about 30 seconds to a minute for the onion address to appear.
    Just refresh the menu after a while."
;;

*)
invalid
;;
esac
done

return 0
}


function menu_electrumx_status {
please_wait

if ! which jq >/dev/null 2>&1 ; then
export electrumx_sync="PLEASE INSTALL JQ FOR THIS TO WORK"
return 0
fi

#get bitcoin block number
source $bc
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/ >/tmp/result 2>&1
gbci=$(cat /tmp/result | grep -E ^{ | jq '.result')

#bitcoin finished?
bsync=$(echo $gbci | jq -r ".initialblockdownload") #true or false

if [[ $bsync == "true" ]] ; then

    export electrumx_sync="Bitcoin still sync'ing"

elif [[ $bsync == "false" ]] ; then
    #fetches block number...
    export electrumx_sync=$(tail -n20 $logfile | grep height | tail -n 1 | grep -Eo 'height.+$' | cut -d : -f 2 | tr -d '[[:space:]],' |\
     grep -Eo '^[0-9]+') >/dev/null

    bblock=$(echo $gbci | jq -r ".blocks")    
debug "bblock is - $bblock ; electrumx_sync is $electrumx_sync"
    if [[ $bblock == $electrumx_sync ]] ; then
    export electrumx_sync="Block $electrumx_sync ${pink}Fully sync'd$orange"
    else
    export electrumx_sync="Up to $electrumx_sync $orange - sync'ing to block $bblock" 
    fi 

    if [[ -z $electrumx_sync ]] ; then
        export electrumx_sync="Wait...$orange"
    fi
fi
}