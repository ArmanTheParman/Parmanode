function menu_btcrpcexplorer {
while true
do
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


    ACCESS THE PROGRAM FROM YOUR BROWSWER:

                  http://127.0.0.1:3002
                

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
esac
done
}
