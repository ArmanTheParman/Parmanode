function menu_electrs {
if ! grep "electrs" $ic  | grep -q end ; then return 0 ; fi
while true ; do

if grep -q "electrsdkr" $ic ; then 
    electrsis=docker
    logfile=$HOME/.electrs/run_electrs.log
else
    electrsis=nondocker
    logfile=$HOME/.electrs/run_electrs.log 
fi

set_terminal

unset electrsrunning
iselectrsrunning

unset ONION_ADDR_ELECTRS E_tor E_tor_logic drive_electrs electrs_version electrs_sync 
source $dp/parmanode.conf >$dn 2>&1

if [[ $electrsrunning == "true" && $1 != fast ]] ; then menu_electrs_status # get electrs_sync variable (block number)
fi

#Tor status
if  [[ -e $macprefix/etc/tor/torrc && $electrsis == "nondocker" && $1 != fast ]] \
    && sudo test -f $macprefix/var/lib/tor/electrs-service/hostname  >$dn 2>&1 ; then
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

set_terminal 40 88

echo -e "
########################################################################################
                                ${cyan}Electrs $electrs_version Menu${orange} 
########################################################################################
"
if [[ $electrsis == "nondocker" && $electrsrunning == "true" ]] ; then
echo -e "
      ELECTRS IS:$green RUNNING$orange

      STATUS:     $green$electrs_sync$orange ($drive_electrs drive)

      CONNECT:$cyan    127.0.0.1:50005:t    $yellow (From this computer only)$orange
              $cyan    127.0.0.1:50006:s    $yellow (From this computer only)$orange 
              $cyan    $IP:50006:s          $yellow \e[G\e[41G(From any home network computer)$orange
                  "
      if [[ -z $ONION_ADDR_ELECTRS ]] && [[ $E_tor_logic == "on" ]] ; then
         echo -e "                  PLEASE WAIT A MOMENT AND REFRESH FOR ONION ADDRESS TO APPEAR"
      elif [[ -n $ONION_ADDR_ELECTRS ]] ; then
         echo -e "
      TOR:$blue        $ONION_ADDR_ELECTRS:7004:t $orange
         $yellow \e[G\e[41G(From any computer in the world)$orange"
      fi
elif [[ $electrsis == "nondocker" && $electrsrunning == "false" ]] ; then
echo -e "
      ELECTRS IS:$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

      Will sync to the $cyan$drive_electrs$orange drive"
fi #end electrs running or not

if [[ $electrsis == docker ]] ; then


if [[ $electrsrunning == "true" ]] ; then echo -en "
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
echo -en "
$green
      start)   $orange  Start electrs $red
      stop) $orange     Stop electrs $cyan
    
      i)$orange         Important info / Troubleshooting $cyan
      remote)$orange    Choose which Bitcoin for electrs to connect to $cyan
      c)$orange         How to connect your Electrum wallet to electrs $cyan	    
      cert)$orange      See electrs SSL certificate$cyan
      log)$orange       Inspect electrs logs $cyan
      ec)$orange        Inspect and edit config file (ecv for vim) $cyan
      dc)$orange        electrs database corrupted? -- Use this to start fresh."
if [[ $electrsis == "nondocker" ]] ; then echo -e "$cyan
      tor)$orange       Enable/Disable Tor connections to electrs -- Status : $E_tor"  ; else echo -e "$cyan      
      newtor)$orange    Refresh Tor address
" 
fi
echo -e "

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
r) menu_electrs || return 1 ;;
p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

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
cert)
sudo true
announce "You can copy this text, and make a file on a remote computer, paste in
    the certificate, then point your Sparrow wallet to it (there is a field for 
    the SSL certificate in the connection window). For Electrum wallet, the 
    certificate is fetched without manual input:

    Here it is:$cyan

$(sudo cat ~/.electrs/cert.pem)

    $orange
    "
;;

log|LOG|Log)

set_terminal ; log_counter
if [[ $log_count -le 15 ]] ; then
echo -e "
########################################################################################
    
    This will show the electrs log output in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue ; jump $enter_cont
fi
set_terminal 38 200

if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
if grep "electrs" $ic | grep -q end && [[ $OS == Linux ]] ; then
NODAEMON="true" ; pn_tmux "tail -f $logfile" ; unset NODAEMON
else
NODAEMON="true" ; pn_tmux "tail -f $logfile" ; unset NODAEMON
fi
TMUX=$TMUX2
;;

ec|EC|Ec|eC)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit$cyan config.toml$orange. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart electrs.

########################################################################################
"
enter_continue ; jump $enter_cont
nano $HOME/.electrs/config.toml
;;

ecv)
vim_warning ; vim $HOME/.electrs/config.toml
;;

tor|TOR|Tor)
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
gbcinfo=$(cat $tmp/result | grep -E ^{ | jq '.result')

#bitcoin finished?
bsync=$(echo $gbcinfo | jq -r ".initialblockdownload") #true or false

if [[ $bsync == "true" ]] ; then

    export electrs_sync="Bitcoin still sync'ing"

elif [[ $bsync == "false" ]] ; then
    #fetches block number...
    export electrs_sync=$(tail -n5 $logfile | grep height | tail -n 1 | grep -Eo 'height.+$' | cut -d = -f 2 | xargs) >$dn
    #in case an unexpected non-number string, printout, otherwise check if full synced.
    if ! echo $electrs_sync | grep -qE '^[0-9]+$' >$dn ; then

        export electrs_sync="Wait...$orange"

    else 
        bblock=$(echo $gbcinfo | jq -r ".blocks")    

        if [[ $bblock == $electrs_sync ]] ; then
        export electrs_sync="Block $electrs_sync ${pink}Fully sync'd$orange"
        else
        export electrs_sync="Up to $electrs_sync $orange - sync'ing to block $bblock" 
        fi 
    fi

    if [[ -z $electrs_sync ]] ; then
        debug "-z \$electrs_sync"
        export electrs_sync="Wait...$orange"
    fi

fi
}