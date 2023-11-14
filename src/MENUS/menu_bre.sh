function menu_bre {
while true
do
unset output enabled output2 t_enabled

#Check if BRE is at local host or in docker container.
if [[ $OS == Mac ]] ; then bre_docker_IP_get 
    local localIP=$breIP 
else 
    local localIP="127.0.0.1"
fi

#check if external connection is enabled
unset enabled && enabled=$(cat $HOME/.parmanode/parmanode.conf | grep "bre_access" | cut -d = -f 2)

#echo outputs for external connection
unset output output2 output3
if [[ $enabled == true && $OS = Linux ]] ; then 
output="    ACCESS THE PROGRAM FROM OTHER COMPUTERS ON THE NETWORK:

                   http://$IP:3003     (Note the port is 3003 not 3002)
                   "
fi

if sudo cat /var/lib/tor/bre-service/hostname  2>&1 | grep -q onion ; then
get_onion_address_variable "bre" >/dev/null 2>&1
output2=" 
        
    ACCESS VIA TOR FROM THE FOLLOWING ONION ADDRESS

                   $ONION_ADDR_BRE:3004
                   "
t_enabled="(currently: enabled)" 
else
t_enabled="(currently: disabled)"
fi
set_terminal_high
echo -e "
########################################################################################
                                ${cyan}BTC RPC EXPLORER${orange}
########################################################################################
"
if [[ $OS == Linux ]] ; then
if sudo systemctl status btcrpcexplorer 2>&1 | grep -q "active (running)" >/dev/null 2>&1 ; then echo -e "
    BTC RPC EXPLORER IS RUNNING 
"
else
echo -e "
    BTC RPC EXPLORER IS$red NOT RUNNING$orange -- CHOOSE \"start\" TO RUN
    "
fi
fi

if [[ $OS == Mac ]] ; then
if  docker ps | grep -q bre ; then echo -e "
    BTC RPC EXPLORER DOCKER CONTAINER IS$green RUNNING$orange
"
else
echo -e "
    BTC RPC EXPLORER DOCKER CONTAINER IS NOT RUNNING -- CHOOSE \"start\" TO RUN
    "
fi
fi

echo -e "

                 (start)    Start BTC RPC EXPLORER

                 (stop)     Start BTC RPC EXPLORER

                 (restart)  Restart BTC RPC EXPLORER 

                 (e)        Enable access from other computers (via nginx)

                 (d)        Disable access from other computers (tcp)

                 (t)        Enable access via Tor $t_enabled

                 (dt)       Disable access via Tor $t_enabled

                 (c)        Edit config file (can manually adjust settings, eg
                                              point to an existing Electrum/Fulcrum
                                              server. Remember to restart afte edits)



    ACCESS THE PROGRAM FROM YOUR BROWSWER ON THE PARMANODE COMPUTER:
$green
                   http://${localIP}:3002 $orange                

$output $output2
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
m|M) back2main ;;
q|Q|Quit|quit) exit 0 ;;
p|P) menu_use ;; 
start|START|Start)
if [[ $OS == Linux ]] ; then start_bre ; fi
if [[ $OS == Mac ]] ; then bre_docker_start ; fi
;;
stop|Stop|STOP)
if [[ $OS == Linux ]] ; then stop_bre ; fi
if [[ $OS == Mac ]] ; then bre_docker_stop ; fi
;;
restart|Restart|RESTART)
if [[ $OS == Linux ]] ; then restart_bre ; fi
if [[ $OS == Mac ]] ; then bre_docker_restart ; fi
;;
e|E|enable|Enable|ENABLE)
if [[ $OS == Linux ]] ; then enable_access_bre ; fi
;;
d|D|Disable|disable|DISABLE)
if [[ $OS == Linux ]] ; then disable_access_bre ; fi
;;
t|T|TOR|tor|Tor)
if [[ $OS == Linux ]] ; then enable_bre_tor ; fi
;;
dt|DT|Dt|dT)
if [[ $OS == Linux ]] ; then disable_bre_tor ; fi
;;
c|C)
if [[ $OS == Linux ]] ; then set_terminal ; nano ~/parmanode/btc-rpc-explorer/.env ; enter_continue ; fi 
if [[ $OS == Mac ]] ; then set_terminal ; nano ~/parmanode/bre/.env ; enter_continue ; fi 
esac
done
}

