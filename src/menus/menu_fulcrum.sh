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

      (c)        How to connect your Electrum wallet to Fulcrum
	    
      (d)        Inspect Fulcrum logs

      (fc)       Inspect and edit fulcrum.conf file 

      (up)       Set/remove/change Bitcoin rpc user/pass in Fulcrum config file


########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in

start | START)
set_terminal
echo "Fulcrum starting..."
sudo systemctl start fulcrum.service
enter_continue
;;

stop | STOP) 
set_terminal
echo "Fulcrum stopping"
enter_continue
;;

c|C)
electrum_wallet_info
continue
;;

d|D)
echo "
########################################################################################
    
    This will show the fulcrum journalctl log output in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
journalctl -fexu fulcrum.service &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal_wider
continue ;;

fc|FC|Fc|fC)
echo "
########################################################################################
    
        This will run Nano text editor to edit fulcrum.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	  Any changes will only be applied once you restart Fulcrum.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
continue
;;

up|UP|Up|uP)
user_pass_fulcrum
continue
;;

p|P)
return 0
;;
*)
invalid
;;


esac
done

return 0
}



