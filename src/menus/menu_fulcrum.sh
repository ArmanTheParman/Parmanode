function menu_fulcrum {
while true
do
set_terminal
echo "
########################################################################################
                                   Fulcrum Menu                               
########################################################################################


      (start)    Start Fulcrum 

      (stop)     Stop Fulcrum 

      (r)        Restart Fulcrum

      (c)        How to connect your Electrum wallet to Fulcrum
	    
      (log)      Inspect Fulcrum logs

      (fc)       Inspect and edit fulcrum.conf file 

      (up)       Set/remove/change Bitcoin rpc user/pass (Fulcrum config file updates)
    
      (wizard)   Connect this Fulcrum server to Bitcoin on a different computer


########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in

start | START)
check_fulcrum_pass
set_terminal
echo "Fulcrum starting..."
if [[ $OS == "Linux" ]] ; then start_fulcrum_linux ; enter_continue ; fi
if [[ $OS == "Mac" ]] ; then start_fulcrum_docker ; fi 
set_terminal
;;

stop | STOP) 
set_terminal
if [[ $OS == "Linux" ]] ; then echo "Fulcrum stopping" ; sudo systemctl stop fulcrum.service ; enter_continue ; fi
if [[ $OS == "Mac" ]] ; then echo "Stopping Fulcrum inside running container..." ; stop_fulcrum_docker ; fi
set_terminal
;;

r|R) 
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
echo "
########################################################################################
    
    This will show the fulcrum log output in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
if [[ $OS == "Linux" ]] ; then
    enter_continue
    set_terminal_wider
    journalctl -fexu fulcrum.service &
    tail_PID=$!
    trap 'kill $tail_PID' SIGINT #condition added to memory
    wait $tail_PID # code waits here for user to control-c
    trap - SIGINT # reset the trap so control-c works elsewhere.
    set_terminal
fi
if [[ $OS == "Mac" ]] ; then
    enter_continue
    set_terminal_wider
    docker exec -it fulcrum tail -f /home/parman/parmanode/fulcrum/fulcrum.log 
    echo ""
    set_terminal
fi
continue ;;

fc|FC|Fc|fC)
if [[ $OS == "Linux" ]] ; then
echo "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	  Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
fi

if [[ $OS == "Mac" ]] ; then
echo "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	  Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
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
if [[ $OS == "Mac" ]] ; then fulcrum_to_remote ; fi
if [[ $OS == "Linux" ]] ; then echo "" ; echo "Only available for Mac, for now." 
enter_continue
fi
;;

*)
invalid
;;
esac
done

return 0
}




