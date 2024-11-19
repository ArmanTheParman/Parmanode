function menu_bre {
set_terminal
while true ; do
set_terminal
unset output t_enabled menubrerunning torstatusD torstatusE

if sudo cat $macprefix/var/lib/tor/bre-service/hostname 2>$dn | grep -q onion \
   && sudo grep -q "bre-service" $torrc \
   && sudo grep -q "3004" $torrc; then

    get_onion_address_variable "bre" 
    output=" 
    ACCESS VIA TOR FROM ANYWHERE IN THE WORLD USING THE FOLLOWING ONION ADDRESS:
                   $bright_blue
            $ONION_ADDR_BRE:3004
                   $orange"
    t_enabled="true"
    torstatusE="${green}Enabled$orange"
else
    torstatusD="${red}Disabled$orange"
    t_enabled="false"
fi


set_terminal_high
echo -e "
########################################################################################
                                ${cyan}BTC RPC EXPLORER${orange}
########################################################################################
"
if [[ $computer_type == LinuxPC ]] ; then
if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >/dev/null 2>&1 ; then echo -e "
        BTC RPC EXPLORER IS$green RUNNING$orange
"
else
echo -e "
        BTC RPC EXPLORER IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN
    "
fi
fi

if [[ $OS == Mac || $computer_type == Pi ]] ; then
if  docker ps 2>/dev/null | grep -q bre ; then 

    if docker exec -itu root bre /bin/bash -c 'ps -xa | grep "btc-rpc"' | grep -v grep >/dev/null 2>&1 ; then
    menubrerunning="true"
    echo -e "

            BTC RPC EXPLORER DOCKER CONTAINER IS$green RUNNING$orange
    "
    else
    echo -e "
            BTC RPC EXPLORER DOCKER CONTAINER IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN
        "
    fi
else
echo -e "
        BTC RPC EXPLORER DOCKER CONTAINER IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN
    "
fi
fi

echo -e "$cyan
                 (start)$orange    Start BTC RPC EXPLORER
$cyan
                 (stop)$orange     Stop BTC RPC EXPLORER
$cyan
                 (restart)$orange  Restart BTC RPC EXPLORER 
$cyan
                 (t)$orange        Enable access via Tor (Linux Only)  $torstatusD
$cyan
                 (td)$orange       Disable access via Tor (Linux Only)  $torstatusE
$cyan
                 (c)$orange        Edit config file (cv for vim)
$cyan
                 (log)$orange      View log file (journalctl)
                                             

    ACCESS THE PROGRAM FROM YOUR BROWSER ON COMPUTERS WITHIN THE HOME NETWORK:
$green
            http://${IP}:${pink}3003 $green 
            http://localhost:3002    $white    -from this computer only          $green
            http://127.0.0.1:3002    $white    -from this computer only $orange

$output
                                                     $red hit r to refresh $orange
########################################################################################
"
choose "xpmq" 
read choice
set_terminal
case $choice in
m|M) back2main ;;
q|Q|Quit|quit) exit 0 ;;
r|R) contine ;; 
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 
start|START|Start)
if [[ $menubrerunning == "true" ]] ; then continue ; fi
if [[ $computer_type == LinuxPC ]] ; then start_bre ; fi
if [[ $OS == Mac || $computer_type == Pi ]] ; then bre_docker_start ; fi
;;
stop|Stop|STOP)
if [[ $computer_type == LinuxPC ]] ; then stop_bre ; fi
if [[ $OS == Mac || $computer_type == Pi ]] ; then bre_docker_stop ; fi
;;
restart|Restart|RESTART)
if [[ $computer_type == LinuxPC ]] ; then restart_bre ; fi
if [[ $OS == Mac || $computer_type == Pi ]] ; then bre_docker_restart ; fi
;;
t|T|TOR|tor|Tor)
if [[ $OS == Linux ]] ; then 
   enable_bre_tor ; debug "after enable bre tor"
fi
;;
td|TD|Td)
if [[ $OS == Linux ]] ; then 
   disable_bre_tor ; debug "after disable bre tor"
fi
;;
c|C)
if [[ $computer_type == LinuxPC ]] ; then set_terminal ; nano ~/parmanode/btc-rpc-explorer/.env ;  fi 
if [[ $OS == Mac || $computer_type == Pi ]] ; then set_terminal ; nano ~/parmanode/bre/.env ;  fi 
;;
cv|CV)
if [[ $computer_type == LinuxPC ]] ; then set_terminal ; vim_warning ; vim ~/parmanode/btc-rpc-explorer/.env ;  fi 
if [[ $OS == Mac || $computer_type == Pi ]] ; then set_terminal ; vim_warning ; vim ~/parmanode/bre/.env ;  fi 
;;

log|LOG|Log)

if [[ $OS == Mac ]] ; then
    no_mac
    continue
fi

set_terminal ; log_counter
if [[ $log_count -le 15 ]] ; then
echo -e "
########################################################################################
    
    This will show the bre journalctl output in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi

if [[ $OS == "Linux" ]] ; then
    set_terminal_wider
    if ! which tmux >$dn 2>&1 ; then
    yesorno "Log viewing needs Tmux installed. Go ahead and to that?" || continue
    fi
    tmux new -s -d "sudo journalctl -fexu btcrpcexplorer.service"
    continue
fi
;;
esac
done
}

