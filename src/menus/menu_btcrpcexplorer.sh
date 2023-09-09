function menu_btcrpcexplorer {
while true
do
unset output enabled output2 t_enabled

enabled=$(cat $HOME/.parmanode/parmanode.conf | grep "bre_access" | cut -d = -f 2)

if [[ $enabled == true ]] ; then 
output="     ACCESS THE PROGRAM FROM OTHER COMPUTERS ON THE NETWORK:

                   http://$IP:3003     (Note the port is 3003 not 3002)"
fi

if sudo cat /var/lib/tor/bre-service/hostname  2>&1 | grep -q onion ; then
get_onion_address_variable "bre" >/dev/null 2>&1
output2=" 
        
    ACCESS VIA TOR FROM THE FOLLOWING ONION ADDRESS

                   $ONION_ADDR_BRE:3004"
t_enabled="(currently: enabled)" 
else
t_enabled="(currently: disabled)"
fi
set_terminal_high
echo "
########################################################################################
                                BTC RPC EXPLORER 
########################################################################################
"
if sudo systemctl status btcrpcexplorer | grep "active (running)" >/dev/null 2>&1 ; then echo "
    BTC RPC EXPLORER IS RUNNING -- SEE LOG MENU FOR PROGRESS 
"
else
echo "
    BTC RPC EXPLORER IS NOT RUNNING -- CHOOSE \"start\" TO RUN"
fi
echo "
                  (start)    Start BTC RPC EXPLORER

                  (stop)     Start BTC RPC EXPLORER

                  (restart)  Restart BTC RPC EXPLORER 

                  (e)        Enable access from other computers (via nginx)

                  (d)        Disable access from other computers (tcp)

                  (t)        Enable access via Tor $t_enabled

                  (dt)       Disable access via Tor $t_enabled

                  (c)        View config file



    ACCESS THE PROGRAM FROM YOUR BROWSWER ON THE PARMANODE COMPUTER:

                   http://127.0.0.1:3002
                
$output $output2

########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in
q|Q|Quit|quit) exit 0 ;;
p|P) return 1 ;;

start|START|Start)
start_bre
;;
stop|Stop|STOP)
stop_bre
;;
restart|Restart|RESTART)
restart_bre
;;
e|E|enable|Enable|ENABLE)
enable_access_bre
;;
d|D|Disable|disable|DISABLE)
disable_access_bre
;;
t|T|TOR|tor|Tor)
enable_bre_tor
;;
dt|DT|Dt|dT)
disable_bre_tor
;;
c|C)
set_terminal ; cat ~/parmanode/btc-rcp-explorer/.env ; enter_continue ;;
esac
done
}

