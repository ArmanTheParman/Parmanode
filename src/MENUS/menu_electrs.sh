function menu_electrs {
while true
do

if sudo cat /etc/tor/torrc | grep "electrs" >/dev/null 2>&1 ; then
    if sudo cat /var/lib/tor/electrs-service/hostname | grep "onion" >/dev/null 2>&1 ; then
    F_tor="on"
    fi
else
    F_tor="off"
fi

set_terminal_custom 45
echo "
########################################################################################
                                   Electrs Menu                               
########################################################################################

"
if ps -x | grep electrs | grep conf >/dev/null 2>&1 ; then echo "
                   ELECTRS IS RUNNING -- SEE LOG MENU FOR PROGRESS 

      127.0.0.1:50005:t    or    127.0.0.1:50006:s    or    $IP:50006:s
"
else
echo "
                   ELECTRS IS NOT RUNNING -- CHOOSE \"start\" TO RUN"
fi
echo "


      (i)        Important info / Troubleshooting

      (start)    Start electrs 

      (stop)     Stop electrs 

      (r)        Restart electrs 

      (c)        How to connect your Electrum wallet to electrs 
	    
      (log)      Inspect electrs logs

      (ec)       Inspect and edit config.toml file 

      (up)       Set/remove/change Bitcoin rpc user/pass (electrs config file updates)
    
      (wizard)   Connect this electrs server to Bitcoin on a different computer
    
      (tor)      Enable Tor connections to electrs-- electrs Tor Status : $F_tor

      (torx)     Disable Tor connection to electrs -- electrs Tor Status : $F_tor



"
if sudo [ -f /var/lib/tor/electrs-service/hostname ] ; then 
get_onion_address_variable "electrs" >/dev/null ; echo "

    Onion adress: $ONION_ADDR_ELECTRS:7005 



########################################################################################
"
else echo "########################################################################################
"
fi
choose "xpq" ; read choice ; set_terminal

case $choice in

I|i|info|INFO)
    info_electrs
    break
    ;;

start | START)
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi 
set_terminal
please_wait
echo "electrs starting.... "
echo ""
if [[ $OS == "Linux" ]] ; then start_electrs ; fi
set_terminal
;;

stop | STOP) 
set_terminal
if [[ $OS == "Linux" ]] ; then echo "electrs stopping" ; stop_electrs ; fi
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
set_terminal
;;

r|R) 
if [[ $OS == "Linux" ]] ; then 
restart_electrs
fi

if [[ $OS == "Mac" ]] ; then
no_mac
return 1
fi
;;

c|C)
electrum_wallet_info
continue
;;

log|LOG|Log)
echo "
########################################################################################
    
    This will show the electrs log output in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
if [[ $OS == "Linux" ]] ; then
    enter_continue
    set_terminal_wider
    journalctl -fexu electrs.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the t. rap so control-c works elsewhere.
    set_terminal
fi

if [[ $OS == "Mac" ]] ; then
no_mac
return 1
fi

continue ;;

ec|EC|Ec|eC)
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################
    
        This will run Nano text editor to edit config.toml. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart electrs.

########################################################################################
"
enter_continue
nano $HOME/.electrs/config.toml
fi
. 
if [[ $OS == "Mac" ]] ; then
no_mac ; return 1 
fi

continue
;;

up|UP|Up|uP)
set_rpc_authentication
continue
;;

p|P)
return 0
;;

q|Q|Quit|QUIT)
exit 0
;;

wizard|Wizard|W|w)
# if [[ $OS == "Mac" ]] ; then fulcrum_to_remote ; fi
# if [[ $OS == "Linux" ]] ; then echo "" ; echo "Only available for Mac, for now." 
# enter_continue
# fi
;;

tor|TOR|Tor)
#fulcrum_tor
;;

torx|TORX|Torx)
#fulcrum_tor_remove
;;

*)
invalid
;;
esac
done

return 0
}




