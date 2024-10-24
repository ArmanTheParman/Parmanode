function menu_fulcrum {
unset refresh


while true
do
set_terminal

isbitcoinrunning
if [[ $bitcoinrunning == "true" ]] ; then
unset isbitcoinrunning_fulcrum
else
isbitcoinrunning_fulcrum="${red}${blinkon}Bitcoin is NOT running${blinkoff}$orange"
fi

if [[ $OS == Linux ]] ; then
if sudo cat /etc/tor/torrc | grep -q "fulcrum" >/dev/null 2>&1 ; then
    if sudo cat /var/lib/tor/fulcrum-service/hostname | grep -q "onion" >/dev/null 2>&1 ; then
    F_tor="on"
    fi
else
    F_tor="off"
fi
fi

source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
#bitcoin_status #fetches block height quicker than getblockchaininfo
unset fulcrum_status fulcrum_sync 
#done this way so first load of menu is fast
if [[ ! $refresh == "true" ]] ; then
fulcrum_status="${blinkon}Type$red r$orange to refresh${blinkoff}$orange"
fulcrum_sync="${blinkon}Type$red r$orange to refresh${blinkoff}$orange"
else
menu_fulcrum_status
fi

set_terminal_custom 47
echo -e "
########################################################################################
                                   ${cyan}Fulcrum Menu${orange}                               
########################################################################################"
if [[ $OS == "Linux" ]] ; then
if ps -x | grep fulcrum | grep conf >/dev/null 2>&1 ; then echo -en "
      FULCRUM IS :$green   RUNNING$orange $isbitcoinrunning_fulcrum 
      STATUS     :   $fulcrum_status
      BLOCK      :   $fulcrum_sync
      DRIVE      :   $drive_fulcrum $orange


      CONNECT  $cyan    127.0.0.1:50001:t    $yellow (From this computer only)$orange
               $cyan    127.0.0.1:50002:s    $yellow (From this computer only)$orange 
               $cyan    $IP:50002:s          $yellow \e[G\e[42G(From any home network computer)$orange
                  "
else
echo -en "$orange
                   $isbitcoinrunning_fulcrum 
                   FULCRUM IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN"
fi #end if ps -x
fi #end if Linux
if [[ $OS == "Mac" ]] ; then
if docker ps 2>/dev/null | grep -q fulcrum && docker exec -it fulcrum bash -c "pgrep Fulcrum" >/dev/null 2>&1 ; then echo -en "

      FULCRUM IS :$green   RUNNING$orange $isbitcoinrunning_fulcrum 
      STATUS     :   $fulcrum_status
      BLOCK      :   $fulcrum_sync
      DRIVE      :   $drive_fulcrum $orange


      CONNECT  $cyan    127.0.0.1:50001:t    $yellow (From this computer only)$orange
               $cyan    127.0.0.1:50002:s    $yellow (From this computer only)$orange 
               $cyan    $IP:50002:s          $yellow \e[G\e[42G(From any home network computer)$orange
                  "
else
echo -ne "
                   $isbitcoinrunning_fulcrum
                   FULCRUM IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN" 
fi
fi

echo -e "
$green
      (start)   $orange Start Fulcrum 
$red
      (stop)  $orange   Stop Fulcrum 

      (restart)  Restart Fulcrum

      (c)        How to connect your Electrum wallet to Fulcrum

      (log)      Inspect Fulcrum logs

      (fc)       Inspect and edit fulcrum.conf file 

      (tor)      Enable Tor connections to Fulcrum -- Fulcrum Tor Status : $F_tor

      (torx)     Disable Tor connection to Fulcrum -- Fulcrum Tor Status : $F_tor

      (newtor)   Refresh Tor address

      (swap)     Swap internal vs external drive sync

      (remote)   Connect this Fulcrum server to Bitcoin Core on a different computer
    
      (dc)       Fulcrum database corrupted? -- Use this to start fresh.
"
if grep -q "fulcrum_tor" < $HOME/.parmanode/parmanode.conf ; then 
get_onion_address_variable "fulcrum"
echo -e "
$bright_blue    Onion adress: $ONION_ADDR_FULCRUM:7002 $orange

########################################################################################
"
else echo -e "########################################################################################
"
fi
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;
r) please_wait ; menu_fulcrum_status ; refresh="true" ;;

start | START)
check_fulcrum_pass
set_terminal
echo "Fulcrum starting..."
if [[ $OS == "Linux" ]] ; then start_fulcrum_linux ; fi
if [[ $OS == "Mac" ]] ; then start_fulcrum_docker ; fi 
set_terminal
;;

stop | STOP) 
set_terminal
echo "Stopping Fulcrum ..."
if [[ $OS == "Linux" ]] ; then stop_fulcrum_linux ; fi
if [[ $OS == "Mac" ]] ; then  stop_fulcrum_docker ; fi
set_terminal
;;

# bitcoin|Bitcoin)
# set_terminal
# bitcoin_core_choice_fulcrum
# set_terminal
# ;;

restart|Rrestart) 
if [[ $OS == "Linux" ]] ; then 
    sudo systemctl restart fulcrum.service
    fi
if [[ $OS == "Mac" ]] ; then
    stop_fulcrum_docker
    start_fulcrum_docker
    fi
;;

c|C)
electrum_wallet_info
continue
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
if [[ $OS == "Linux" ]] ; then
    set_terminal_wider
    sudo journalctl -fexu fulcrum.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT EXIT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the trap so control-c works elsewhere.
    set_terminal
fi
if [[ $OS == "Mac" ]] ; then
    set_terminal_wider
    docker exec -it fulcrum tail -f /home/parman/parmanode/fulcrum/fulcrum.log 
    echo ""
    set_terminal
fi
continue ;;

fc|FC|Fc|fC)
if [[ $OS == "Linux" ]] ; then
echo -e "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit.$red Be careful messing around with this file. $orange

        Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
fi

if [[ $OS == "Mac" ]] ; then
echo -e "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit.$red Be careful messing around with this file. $orange

        Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
fi

continue
;;

p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

q|Q|Quit|QUIT)
exit 0
;;

Remote|REMOTE|remote)
if [[ $OS == "Mac" ]] ; then fulcrum_to_remote ; fi
if [[ $OS == "Linux" ]] ; then echo "" ; echo "Only available for Mac, for now." 
enter_continue
fi
;;

tor|TOR|Tor)
fulcrum_tor
;;

torx|TORX|Torx)
fulcrum_tor_remove
;;

newtor)
sudo rm -rf /var/lib/tor/fulcrum-service
sudo systemctl restart tor
announce "You need to wait about 30 seconds to a minute for the onion address to appear.
    Just refresh the menu after a while."
;;

swap)
swap_fulcrum_drive
;;

dc|DC|Dc|dC)
fulcrum_database_corrupted
;;

*)
invalid
;;
esac
done

return 0
}


function menu_fulcrum_status {
local file="/tmp/fulcrum.journal"

if [[ $OS == Mac ]] ; then
    if docker ps >/dev/null ; then
        docker exec -it fulcrum /bin/bash -c "cat /home/parman/parmanode/fulcrum/fulcrum.log" > $file 2>&1
    else
       echo "Docker not running." > $file 
    fi
else
sudo journalctl -exu fulcrum.service > $file 2>&1
fi

if tail -n1 $file | grep -q 'Processed height:' ; then
export fulcrum_status=syncing
#fetches block number...
export fulcrum_sync=$(sudo journalctl -exu fulcrum.service | tail -n1 $file | grep Processed | grep blocks/ | grep addrs/ \
| grep -Eo 'Processed height:.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
rm $file
return 0
fi

if tail -n20 /tmp/fulcrum.journal | grep -q "up-to-date" ; then
export fulcrum_status=up-to-date
#fetches block number...
export fulcrum_sync=$(tail -n20 /tmp/fulcrum.journal | grep "up-to-date" | \
tail -n1 | grep -Eo 'Block height.+$' | grep -Eo '[0-9].+$' | cut -d , -f 1)
rm $file
return 0
fi

fulcrum_status="See log for info"
fulcrum_sync="?"
rm $file
return 0
}


function swap_fulcrum_drive {
# The docker version volume mounts to the external/internal drive at run
# command. To change it, it's more complicated, will do that later for Mac.
if [[ $OS == Mac ]] ; then no_mac ; return 0 ; fi

#check parmanode.conf variable setting.
source $pc

if [[ $drive_fulcrum == internal ]] ; then other="external" 
elif [[ $drive_fulcrum == external ]] ; then other="internal"
else announce "Unable to fetch drive status from parmanode.conf configuration file"
     return 1
fi

#from that, make confirmation window
while true ; do
set_terminal ; echo -en "
########################################################################################

    You are currently syncing Fulcrum data to the$cyan $drive_fulcrum drive$orange. Would you
    like to swap over to the$cyan $other drive$orange? 

$pink
    You will not lose data unless you instruct Parmanode to delete stuff.
    Also, no data is transferred form one drive to the other with this tool, it's 
    sipmly changing the syncing location.
$orange


                        s)       Swap to $other drive

                        a)       Nah, abort


########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; a|A|N|n|no) return 0 ;; M|m) back2main ;; s) break ;; *) invalid ;; 
esac
done

#stop fulcrum
please_wait
stop_fulcrum

#check drive mounted
if [[ $other == external ]] ; then
if ! mount | grep -q parmanode ; then
announce "Please make sure the drive is mounted."
if ! mount | grep -q parmanode ; then
announce "Drive not mounted. Aborting."
return 1
fi 
fi
fi

#get space left on target drive
if [[ $other == external ]] ; then
space=$(df -h $parmanode_drive | awk '{print $4}' | tail -n1)
elif [[ $other == internal ]] ; then
space=$(df -h / | awk '{print $4}' | tail -n1)
fi

while true ; do
set_terminal ; echo -en "
########################################################################################

    Just FYI, you have$cyan $space$orange of space left on the$cyan $other$orange drive.

    Continue?

                                y)        Yes

                                n)        No

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|q) exit 0 ;; p|P) return 0 ;; n|N) return 0 ;; M|m) back2main ;; y) break ;; *) invalid ;;
esac
done

# Then check directory exists, then make if necessary 
if [[ $other == external && ! -e $parmanode_drive/fulcrum_db ]] ; then
sudo mkdir $parmanode_drive/fulcrum_db
sudo chown -R $USER $parmanode_drive/fulcrum_db
fi

if [[ $other == internal && ! -e $HOME/.fulcrum_db ]] ; then
mkdir $HOME/.fulcrum_db
fi

#swap string for fulcrum.conf
if [[ $other == internal ]] ; then
swap_string "$hp/fulcrum/fulcrum.conf" "datadir =" "datadir = $HOME/.fulcrum_db"
elif [[ $other == external ]] ; then
swap_string "$hp/fulcrum/fulcrum.conf" "datadir =" "datadir = $parmanode_drive/fulcrum_db"
fi

#correct parmanode conf variable
parmanode_conf_remove "drive_fulcrum="
parmanode_conf_add "drive_fulcrum=$other"
success "The Fulcrum sync directory has been swapped over to the$cyan $other$orange drive.

    Start Fulcrum when you're ready."
}
