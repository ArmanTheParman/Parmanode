function menu_electrs {

if grep -q "electrsdkr" $ic ; then #dont use electrsdkr2
    electrsis=docker
    logfile=$HOME/.electrs/run_electrs.log
    #docker exec electrs cat /home/parman/run_electrs.log > $logfile
else
    electrsis=nondocker
    logfile=$HOME/.parmanode/run_electrs.log 
    if [[ $OS == Linux ]] ; then
       sudo journalctl -exu electrs.service > $logfile 2>&1
    elif [[ $OS == Mac ]] ; then
    # Background process is writing continuously to $logfile.
    true #do nothing, sturctured so for readability.
    fi
fi

while true ; do

set_terminal

#is electrs running variable
unset running runningd
if [[ $electrsis == nondocker ]] ; then
    if ps -x | grep electrs | grep conf >$dn 2>&1  && ! tail -n 10 $logfile 2>$dn | grep -q "electrs failed"  ; then 
    running="true"
    else
    running="false"
    fi
else 
    if docker ps | grep -q electrs && docker exec electrs ps | grep electrs ; then
    running="true"
    else
    running="false"
    fi
fi

unset ONION_ADDR_ELECTRS E_tor E_tor_logic drive_electrs electrs_version electrs_sync 
source $dp/parmanode.conf >$dn 2>&1

if [[ $running == "true" && $1 != fast ]] ; then menu_electrs_status # get elecyrs_sync variable (block number)
fi

#Tor status
if  [[ -e $macprefix/etc/tor/torrc && $electrsis == nondocker && $1 != fast ]] \
    && sudo grep -q "electrs" $macprefix/etc/tor/torrc \
    && grep -q "electrs_tor=true" $pc \
    && sudo cat $macprefix/var/lib/tor/electrs-service/hostname | grep -q "onion" >$dn 2>&1 ; then

        E_tor="${green}on${orange}"
        E_tor_logic=on
        get_onion_address_variable "electrs" 
else
        E_tor="${red}off${orange}"
        E_tor_logic=off

fi

#Tor is always on for docker electrs
if [[ $electrsis == docker && $1 != fast ]] ; then
        ONION_ADDR_ELECTRS=$(docker exec -u root electrs cat /var/lib/tor/electrs-service/hostname)
fi

#Get version
if [[ $electrsis == docker && $1 != fast ]] ; then
    if docker exec electrs /home/parman/parmanode/electrs/target/release/electrs --version >$dn 2>&1 ; then
        electrs_version=$(docker exec electrs /home/parman/parmanode/electrs/target/release/electrs --version | tr -d '\r' 2>$dn )
        if docker exec -it electrs /bin/bash -c "tail -n 10 $logfile" | grep -q "electrs failed" ; then unset electrs_version 
        fi
    fi
else #electrsis nondocker
        electrs_version=$($HOME/parmanode/electrs/target/release/electrs --version 2>$dn)
fi
set_terminal_custom 50

echo -e "
########################################################################################
                                ${cyan}Electrs $electrs_version Menu${orange} 
########################################################################################
"
if [[ $electrsis == nondocker && $running == "true" ]] ; then
echo -e "
      ELECTRS IS:$green RUNNING$orange

      STATUS:     $green$electrs_sync$orange ($drive_electrs drive)

      CONNECT:$cyan    127.0.0.1:50005:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50006:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50006:s          $yellow \e[G\e[41G(From any home network computer)$orange
                  "
      if [[ -z $ONION_ADDR_ELECTRS ]] ; then
         echo -e "                  PLEASE WAIT A MOMENT AND REFRESH FOR ONION ADDRESS TO APPEAR"
      else
         echo -e "
      TOR:$bright_blue 
                  $ONION_ADDR_ELECTRS:7004:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange"
      fi
elif [[ $electrsis == nondocker && $running == "false" ]] ; then
echo -e "
      ELECTRS IS:$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

      Will sync to the $cyan$drive_electrs$orange drive"
fi #end electrs running or not

if [[ $electrsis == docker ]] ; then

if ! docker ps 2>$dn | grep -q electrs ; then echo -e "
$red $blinkon
                   DOCKER CONTAINER IS NOT RUNNING
$blinkoff$orange"
fi
if [[ $running == "true" ]] ; then echo -e "
      ELECTRS IS:$green RUNNING$orange

      STATUS:     $green$electrs_sync$orange ($drive_electrs drive)

      CONNECT:$cyan    127.0.0.1:50005:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50006:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50006:s          $yellow \e[G\e[41G(From any home network computer)$orange

      DOCKER TOR ONLY:
                 $bright_blue $ONION_ADDR_ELECTRS:7004:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange      " 

else
echo -e "
                   ELECTRS IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

                   Will sync to the $cyan$drive_electrs$orange drive"
fi
fi #end electrsis docker
echo -e "

$green
      (start)   $orange Start electrs 
$red
      (stop) $orange    Stop electrs 
$cyan
      (restart)$orange  Restart electrs
$cyan
      (i)$orange        Important info / Troubleshooting
$cyan
      (remote)$orange   Choose which Bitcoin Core for electrs to connect to
$cyan
      (c)$orange        How to connect your Electrum wallet to electrs 
$cyan	    
      (log)$orange      Inspect electrs logs
$cyan
      (ec)$orange       Inspect and edit config file (ecv for vim)
$cyan
      (dc)$orange       electrs database corrupted? -- Use this to start fresh."

if [[ $OS == Linux && $electrsis == nondocker ]] ; then echo -e "$cyan
      (tor)$orange      Enable/Disable Tor connections to electrs -- Status : $E_tor"  ; else echo -e "
$cyan      
      (newtor)$orange   Refresh Tor address
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
info_electrs
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
docker start electrs >$dn 2>&1 #starts container
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
enter_continue "
########################################################################################
    
    This will show the electrs log output in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
fi

set_terminal_wider
tail -f $logfile & 
tail_PID=$!
trap 'kill $tail_PID' SIGINT EXIT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the t. rap so control-c works elsewhere.
set_terminal
menu_electrs #this is so the status refreshes 
;;

ec|EC|Ec|eC)
enter_continue "
########################################################################################
    
        This will run Nano text editor to edit config.toml. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart electrs.

########################################################################################
"

nano $HOME/.electrs/config.toml
 
;;

ecv)
vim_warning ; vim $HOME/.electrs/config.toml
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

newtor)
sudo rm -rf $macprefix/var/lib/tor/electrs-service
restart_tor
announce "You need to wait about 30 seconds to a minute for the onion address to appear.
    Just refresh the menu after a while."
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

if ! which jq >$dn 2>&1 ; then
export electrs_sync="PLEASE INSTALL JQ FOR THIS TO WORK"
return 0
fi

#get bitcoin block number
source $bc
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/ >$tmp/result 2>&1
gbci=$(cat $tmp/result | grep -E ^{ | jq '.result')

#bitcoin finished?
bsync=$(echo $gbci | jq -r ".initialblockdownload") #true or false

if [[ $bsync == "true" ]] ; then

    export electrs_sync="Bitcoin still sync'ing"

elif [[ $bsync == "false" ]] ; then
    #fetches block number...
    export electrs_sync=$(tail -n5 $logfile | grep height | tail -n 1 | grep -Eo 'height.+$' | cut -d = -f 2 | tr -d '[[:space:]]') >$dn
    #in case an unexpected non-number string, printout, otherwise check if full synced.
    if ! echo $electrs_sync | grep -qE '^[0-9]+$' >$dn ; then

        export electrs_sync="Wait...$orange"

    else 
        bblock=$(echo $gbci | jq -r ".blocks")    

        if [[ $bblock == $electrs_sync ]] ; then
        export electrs_sync="Block $electrs_sync ${pink}Fully sync'd$orange"
        else
        export electrs_sync="Up to $electrs_sync $orange - sync'ing to block $bblock" 
        fi 
    fi

    if [[ -z $electrs_sync ]] ; then
        export electrs_sync="Wait...$orange"
    fi
fi
}