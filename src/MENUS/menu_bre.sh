function menu_bre {
set_terminal
while true
do
unset output enabled output2 t_enabled menubrerunning

#check if external connection is enabled
unset enabled && enabled=$(cat $HOME/.parmanode/parmanode.conf | grep "bre_access" | cut -d = -f 2)

#echo outputs for external connection
unset output output2 output3
if [[ $enabled == true && $computer_type = LinuxPC ]] ; then 
output="    ACCESS THE PROGRAM FROM OTHER COMPUTERS ON THE NETWORK:

                   http://$IP:3003     (Note the port is 3003 not 3002)
                   "
fi

if sudo cat /var/lib/tor/bre-service/hostname  2>&1 | grep -q onion ; then
get_onion_address_variable "bre" >/dev/null 2>&1
output2=" 
    ACCESS VIA TOR FROM THE FOLLOWING ONION ADDRESS
                   $bright_blue
                   $ONION_ADDR_BRE:3004
                   $orange
                   "
t_enabled=true
else
t_enabled=false
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
    menubrerunning=true
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

echo -e "
                 (start)    Start BTC RPC EXPLORER

                 (stop)     Stop BTC RPC EXPLORER

                 (restart)  Restart BTC RPC EXPLORER 

                 (t)        Enable/Disable access via Tor (Linux Only)

                 (c)        Edit config file 
                                             

    ACCESS THE PROGRAM FROM YOUR BROWSER ON THE PARMANODE COMPUTER:
$green
                   http://${IP}:3002     
                   http://localhost:3002        -from this computer only
                   http://127.0.0.1:3002        -from this computer only$orange                

$output $output2
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;
q|Q|Quit|quit) exit 0 ;;
p|P) menu_use ;; 
start|START|Start)
if [[ $menubrerunning == true ]] ; then continue ; fi
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
   if [[ $t_enabled == false ]] ; then enable_bre_tor 
   else disable_bre_tor
   fi
fi
;;
c|C)
if [[ $computer_type == LinuxPC ]] ; then set_terminal ; nano ~/parmanode/btc-rpc-explorer/.env ;  fi 
if [[ $OS == Mac || $computer_type == Pi ]] ; then set_terminal ; nano ~/parmanode/bre/.env ;  fi 
esac
done
}

