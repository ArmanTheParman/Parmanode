function menu_electrumx {
if ! grep -q "electrumx-end" $ic ; then return 0 ; fi
unset refresh
logfile=$HOME/.parmanode/run_electrumx.log 

while true ; do
unset log_size 

#no need to check log size only if log is from journalctl output, otherwise
#log file is growing from a process output with '>>'
if [[ $OS == Mac ]] ; then 
log_size=$(ls -l $logfile | awk '{print $5}'| grep -oE [0-9]+)
log_size=$(echo $log_size | tr -d '\r\n')
fi
set_terminal

#get iselectrumxrunning variable
unset running runningd
iselectrumxrunning
debug "ex status: $electrumxrunning"

unset ONION_ADDR_ELECTRUMX E_tor E_tor_logic drive_electrumx electrumx_version electrumx_sync 
source $dp/parmanode.conf >$dn 2>&1

if [[ $refresh == "true" ]] ; then
    if [[ $electrumxrunning == "true" ]] ; then 
        menu_electrumx_status # get electrumx_sync variable (block number)
    fi
else
    electrumx_sync="${blinkon}${orange}Type$red r$orange to refresh${blinkoff}$orange"
fi

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then

    if sudo cat $macprefix/etc/tor/torrc 2>$dn | grep -q "electrumx" ; then
        if [[ -e $macprefix/var/lib/tor/electrumx-service ]] && \
        sudo cat $macprefix/var/lib/tor/electrumx-service/hostname | grep "onion" >$dn 2>&1 ; then
        E_tor="${green}on${orange}"
        E_tor_logic=on
        else
        E_tor="${yellow}wait${orange}"
        E_tor_logic=on
        fi

        if grep -q "electrumx_tor=true" $pc ; then 
        get_onion_address_variable "electrumx" 
        fi
    else
        E_tor="${red}off${orange}"
        E_tor_logic=off
    fi
fi

#Get version
electrumx_version=$(grep -Eo 'software version: ElectrumX.+$' $logfile | tail -n1 | grep -Eo [0-1].+$ | xargs)

if grep -q "disable_electrumx=true" $pc ; then
         disable_output="\n\n      ELECTRUMX IS$red DISABLED (type disable to toggle)$orange" 
else
unset disable_output
fi

set_terminal  50 88 ; echo -en "
########################################################################################
                                ${cyan}Electrum X $electrumx_version Menu${orange} 
########################################################################################$disable_output
"
if [[ -n $log_size && $log_size -gt 100000000 ]] ; then echo -e "$red
    THE LOG FILE SIZE IS GETTING BIG. TYPE 'logdel' AND <enter> TO CLEAR IT.
    $orange"
fi

if [[ $electrumxrunning == "true" ]] ; then
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
elif [[ $electrumxrunning == "false" ]] ; then
echo -en "
      ELECTRUMX IS:$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN

      Will sync to the $cyan$drive_electrumx$orange drive"
fi #end electrumx running or not

echo -e "

$green
      start)$orange    Start Electrum X $red
      stop)$orange     Stop Electrum X $red
      disable)$orange  Toggle on/off (for when manually copying data)$cyan
      restart)$orange  Restart Electrum X $cyan
      remote)$orange   Choose which Bitcoin instance for Electrum X to connect to $cyan
      cert)$orange     See ElectrumX SSL certificate$cyan
      log)$orange      Inspect Electrum X logs $cyan
      ec)$orange       Inspect and edit config file (ecv for vim) $cyan
      dc)$orange       Electrum X database corrupted? -- Use this to start fresh."
if [[ $OS == Linux ]] ; then echo -e "${cyan}tor)$orange      Enable/Disable Tor connections to Electrum X -- Status : $E_tor"  
else echo -e "${cyan}newtor)$orange   Refresh Tor address
" 
fi
echo -e "
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 
dc)
yesorno "This will delete the Electrum X database and start fresh. Are you sure?" || continue
stop_electrumx
sudo rm -rf $hp/.electrumx_db/*
sudo chown -R $USER $hp/.electrumx_db
success "Electrum X database deleted. You can now start Electrum X."
;;
r) 
please_wait
refresh="true"
menu_electrumx || return 1 
;;

start | START)
start_electrumx 
sleep 1
;;

stop | STOP) 
stop_electrumx
;;

disable)
stop_electrumx
disable_electrumx
;;
logdel)
please_wait
stop_electrumx
rm $logfile
start_electrumx
;;

restart|Restart)
restart_electrumx
sleep 2
;;

remote|REMOTE|Remote)
set_terminal
electrumx_to_remote
restart_electrumx
set_terminal
;;

c|C)
electrum_wallet_info
continue
;;

cert)
sudo true
announce "
    You can copy this text, and make a file on a remote computer, paste in
    the certificate, then point your Sparrow wallet to it (there is a field for 
    the SSL certificate in the connection window). For Electrum wallet, the 
    certificate is fetched without manual input:

    Here it is:$cyan

$(sudo cat $hp/electrumx/cert.pem)
    $orange "
;;

log|LOG|Log)

set_terminal ; log_counter
if [[ $log_count -le 15 ]] ; then
echo -e "
########################################################################################
    
    This will show the Electrum X log output in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue ; jump $enter_cont

fi
if [[ $OS == Mac ]] ; then
    set_terminal 38 200
    if ! which tmux >$dn 2>&1 ; then
    yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
    fi
    TMUX2=$TMUX ; unset TMUX ; clear
    tmux attach-session -t electrumx_log 2>/dev/null || {
    tmux new -s electrumx_log "tail -f $logfile" 
    }
    TMUX=$TMUX2
    set_terminal
fi

if [[ $OS == "Linux" ]] ; then
    set_terminal 38 200
    if ! which tmux >$dn 2>&1 ; then
    yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
    fi
    TMUX2=$TMUX ; unset TMUX ; clear
    tmux new -s -d "journalctl -fexu electrumx.service"
    TMUX=$TMUX2
fi
;;

ec|EC|Ec|eC)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit$cyan electrumx.conf$orange. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart Electrum X.

########################################################################################
"
enter_continue ; jump $enter_cont
nano $hp/electrumx/electrumx.conf
;;
ecv|ECV)
vim_warning ; vim $hp/electrumx/electrumx.conf
;;

up|UP|Up|uP)
set_rpc_authentication
continue
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
sudo rm -rf $macprefix/var/lib/tor/electrumx-service
restart_tor
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

if ! which jq >$dn 2>&1 ; then
export electrumx_sync="PLEASE INSTALL JQ FOR THIS TO WORK"
return 0
fi

#get bitcoin block number
source $bc
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/ >$tmp/result 2>&1
gbci=$(cat $tmp/result | grep -E ^{ | jq '.result')

#bitcoin finished?
bsync=$(echo $gbci | jq -r ".initialblockdownload") #true or false

if [[ $bsync == "true" ]] ; then

    export electrumx_sync="Bitcoin still sync'ing"

elif [[ $bsync == "false" ]] ; then
    #fetches block number...
    export electrumx_sync=$(tail -n20 $logfile | grep height | tail -n 1 | grep -Eo 'height.+$' | cut -d : -f 2 | xargs | grep -Eo '^[0-9]+') >$dn

    bblock=$(echo $gbci | jq -r ".blocks")    

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

function iselectrumxrunning {
if pgrep electrumx >$dn 2>&1 ; then
export electrumxrunning="true"
else
export electrumxrunning="false"
fi
}


function disable_electrumx {
clear

if grep -q "disable_electrumx=true" $pc ; then #electrumx is disabled, enable it...

        sudo systemctl enable electrumx.service
        sudo gsed -i "/disable_electrumx=true/d" $pc #delete line

else #electrumx is not disabled, disable it...
        sudo systemctl disable electrumx.service
        echo "disable_electrumx=true" | tee -a $pc >$dn 2>&1 #add line
fi
}