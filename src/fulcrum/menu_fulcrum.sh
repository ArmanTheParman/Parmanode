function menu_fulcrum {
if ! grep "fulcrum" $ic | grep -q end ; then return 0 ; fi
[[ -e $HOME/.fulcrum/fulcrum.log ]] && [[ ! -r $HOME/.fulcrum/fulcrum.log ]] && sudo chown $USER:$(id -gn) +x $HOME/.fulcrum/fulcrum.log
while true ; do
please_wait
source $pc

if [[ $configure_bitcoin_self == "true" ]] ; then
isbitcoinrunning=UNKNOWN
else
isbitcoinrunning
fi

if [[ $bitcoinrunning == "true" ]] ; then
unset isbitcoinrunning_fulcrum
elif [[ $bitcoinrunning == "false" ]] ; then
isbitcoinrunning_fulcrum="${red}${blinkon}Bitcoin is NOT running${blinkoff}$orange"
fi

if    sudo cat $macprefix/etc/tor/torrc 2>$dn | grep -q "fulcrum" >$dn 2>&1 \
   && sudo cat $macprefix/var/lib/tor/fulcrum-service/hostname | grep -q "onion" >$dn 2>&1 ; then

    F_tor="${green}on$orange"
    f_tor="on" 

else
    F_tor="${red}off$orange"
    f_tor="off"
fi

unset fulcrum_status fulcrum_sync fulcrum_status2
menu_fulcrum_status

isfulcrumrunning 

if is_fulcrum_shutting_down ; then
RUNNING="SHUTTING DOWN..."
else
RUNNING="RUNNING"
fi

fulcrum_status2="$fulcrum_status -- $red<enter> to refresh status$orange"

set_terminal  47 88
echo -e "
########################################################################################
                                   ${cyan}Fulcrum Menu${orange}                               
########################################################################################"
if [[ $fulcrumrunning == "true" ]] ; then echo -en "
      FULCRUM IS :$green   $RUNNING$orange 
      STATUS     :   $fulcrum_status2
      BLOCK      :   $fulcrum_sync 
      DRIVE      :   $drive_fulcrum $orange


      CONNECT  $cyan    127.0.0.1:50001:t    $yellow (From this computer only)$orange
               $cyan    127.0.0.1:50002:s    $yellow (From this computer only)$orange 
               $cyan    $IP:50002:s          $yellow \e[G\e[42G(From any home network computer)$orange
                  "
   else
echo -en "$orange
                   FULCRUM IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi
echo -e "
$green
      start)   $orange Start Fulcrum $red
      stop)  $orange   Stop Fulcrum $cyan
      restart)$orange  Restart Fulcrum $cyan
      c)$orange        How to connect your Electrum wallet to Fulcrum $cyan
      cert)$orange     See Fulcrum SSL certificate$cyan
      log)$orange      Inspect Fulcrum logs (real time) $cyan
      brlog)$orange    Browse Fulcrum log (static) $cyan
      fc)$orange       Inspect and edit fulcrum.conf file (fcv for vim) $cyan
      tor)$orange      Toggle Tor connections to Fulcrum -- Fulcrum Tor Status : $F_tor $cyan
      dc)$orange       Fulcrum database corrupted? -- Use this to start fresh.
"
if grep -q "fulcrum_tor" $HOME/.parmanode/parmanode.conf ; then 
get_onion_address_variable "fulcrum"
echo -e "
$bright_blue    Onion adress: $ONION_ADDR_FULCRUM:7002 $orange

########################################################################################
"
else echo -e "########################################################################################
"
fi
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use 
;;
r) please_wait ; menu_fulcrum_status ;; 

start | START)
set_terminal
echo "Fulcrum starting..."
start_fulcrum 
set_terminal
;;

stop | STOP) 
set_terminal
echo "Stopping Fulcrum ..."
stop_fulcrum 
set_terminal
;;

restart|Rrestart) 
    stop_fulcrum
    start_fulcrum
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

$(sudo cat ~/.fulcrum/cert.pem)
    $orange "
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
set_terminal 38 200
if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
tmux new -s fulcrum_log "tail -f $HOME/.fulcrum/fulcrum.log"
TMUX=$TMUX2
set_terminal
;;
brlog)
set_terminal
log_counter
if [[ $log_count -le 20 ]] ; then
echo -e "
########################################################################################
    
    This will show the fulcrum log statically, allowing you to browse and look for
    any errors.$red q$orange to exit.

########################################################################################
"
enter_continue
fi

if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
NODAEMON="true" ; pn_tmux "less -R $HOME/.fulcrum/fulcrum.log" ; unset NODAEMON
TMUX=$TMUX2
set_terminal
;;
fc|FC|Fc|fC)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit.$red Be careful messing around with this file. $orange

        Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
sudo nano $fc
;;

fcv)
vim_warning 
sudo vim $fc
;;

tor|TOR|Tor)
if [[ $f_tor == "off" ]] ; then
fulcrum_tor
else
fulcrum_tor_remove
fi
;;

dc|DC|Dc|dC)
fulcrum_database_corrupted
;;
"")
continue
;;
*)
invalid
;;
esac
done

return 0
}


function menu_fulcrum_status {
local file="$HOME/.fulcrum/fulcrum.log"
[ -e $file ] || touch $file 

if tail -n10 $file | grep -q 'Processed height:' ; then export fulcrum_status=syncing #fetches block number..

export fulcrum_sync=$(tail -n10 $file | grep Processed | tail -n1 | grep blocks/ | grep addrs/ \
| grep -Eo 'Processed height:.+,' | grep -Eo '[0-9].+$' | cut -d , -f 1)

return 0
fi

if tail -n20 $file | grep -q "up-to-date" ; then
      export fulcrum_status=up-to-date
      #fetches block number...
      export fulcrum_sync=$(tail -n20 $$file | grep "up-to-date" | \
      tail -n1 | grep -Eo 'Block height.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
      return 0
fi

fulcrum_status="See log for info"
fulcrum_sync="?"
return 0
}

function is_fulcrum_shutting_down {
if ! grep -q "fulcrumdkr" $ic ; then return 1 ; fi

if docker exec -it fulcrum bash -c "cat /home/parman/.fulcrum/fulcrum.log  | tail -n1 | grep 'exiting' " \
|| docker exec -it fulcrum bash -c "cat /home/parman/.fulcrum/fulcrum.log  | tail -n1 | grep 'Shutdown requested via signal' " \
|| docker exec -it fulcrum bash -c "cat /home/parman/.fulcrum/fulcrum.log  | tail -n1 | grep 'Stopping' " \
|| docker exec -it fulcrum bash -c "cat /home/parman/.fulcrum/fulcrum.log  | tail -n1 | grep 'Closing' "  ; then
return 0
else
return 1
fi
}
