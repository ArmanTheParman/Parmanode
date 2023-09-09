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
esac
done
}

function start_bre {
check_config_bre || return 1
sudo systemctl start btcrpcexplorer.service >/dev/null
}

function stop_bre {
sudo systemctl stop btcrpcexplorer.service >/dev/null
return 1
}

function restart_bre {
stop_bre ; start_bre
}

function check_config_bre {

#btc_authentication in parmanode.conf is either "user/pass" or "cookie"

if ! cat ~/.parmanode/parmanode.conf | grep -q btc_authentication ; then #if the setting doesn't exist 
    announce "There is a fault with the parmanode configuration file" \
    "No btc_authentication setting found. Aborting."
    enter_continue
    return 1
fi

btc_auth=$(cat ~/.parmanode/parmanode.conf | grep btc_authentication | cut -d = -f 2 ) #get value on right side of =
if cat $HOME/parmanode/btc-rpc-explorer/.env | grep COOKIE= ; then bre_auth=cookie ; fi
if cat $HOME/parmanode/btc-rpc-explorer/.env | grep USER= ; then bre_auth="user/pass" ; fi

if [[ $btc_auth == "cookie" && $bre_auth == "cookie" ]] ; then return 0 ; fi #settings match, can proceed
if [[ $btc_auth == "user/pass" && $bre_auth == "user/pass" ]] ; then return 0 ; fi #settings match, can proceed

# if code reaches here, changes need to be made.
if [[ $btc_auth == "cookie" ]] ; then
    delete_line "$HOME/parmanode/btc-rpc-explorer/.env" "USER=" 
    delete_line "$HOME/parmanode/btc-rpc-explorer/.env" "PASS="
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" >> $HOME/parmanode/btc-rpc-explorer/.env 
    return 0
    fi

if [[ $btc_auth == "user/pass" ]] ; then
    delete_line "$HOME/parmanode/btc-rpc-explorer/.env" "COOKIE="
    echo "BTCEXP_BITCOIND_USER=$rpcuser" >> $HOME/parmanode/btc-rpc-explorer/.env 
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" >> $HOME/parmanode/btc-rpc-explorer/.env 
    return 0
    fi
}