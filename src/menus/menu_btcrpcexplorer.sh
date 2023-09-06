function menu_btcrpcexplorer {
while true
do
unset output
unset enabled
enabled=$(cat $HOME/.parmanode/parmanode.conf | grep "bre_access" | cut -d = -f 2)

if [[ $enabled == true ]] ; then 
output="     ACCESS THE PROGRAM FROM OTHER COMPUTERS ON THE NETWORK:

                   http://$IP:3003     Note the port is 3003 not 3002"
fi
set_terminal

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

                  (d)        Disable access from other computers


    ACCESS THE PROGRAM FROM YOUR BROWSWER ON THE PARMANODE COMPUTER:

                  http://127.0.0.1:3002
                
$output

########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in
q|Q|Quit|quit) exit 0 ;;
p|P) return 1 ;;

start|START|Start)
sudo systemctl start btcrpcexplorer.service >/dev/null
;;
stop|Stop|STOP)
sudo systemctl stop btcrpcexplorer.service >/dev/null
;;
restart|Restart|RESTART)
sudo systemctl restart btcrpcexplorer.service >/dev/null
;;
e|E|enable|Enable|ENABLE)
enable_access_bre
;;
d|D|Disable|disable|DISABLE)
disable_access_bre
;;
esac
done
}
