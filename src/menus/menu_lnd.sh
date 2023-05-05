function menu_lnd {
while true ; do ; set_terminal ; echo "
########################################################################################
                                     LND Menu                               
########################################################################################

      (start)          Start LND 

      (stop)           Stop LND

      (restart)        Restart LND
	    
      (log)            Inspect LND logs

      (conf)           Inspect and edit lnd.conf file 

      (password)       Change LND password 
       
      (alias)          Change LND alias

      (wallet)         create an LND wallet

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;
start|START|Start) sudo systemctl start lnd.service ;;
stop|STOP|Stop) sudo systemctl stop lnd.service ;; 
restart|RESTART|Restart) sudo systemctl restart lnd.service ;;

log|LOG|Log)
echo "
########################################################################################
    
    This will show the systemd output for LND in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
sudo journalctl -fxu lnd.service 
journal_PID=$!
trap 'kill $journal_PID' SIGINT #condition added to memory
wait $journal_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
;;


conf|CONF|Conf)
echo "
########################################################################################
    
        This will run Nano text editor to edit lnd.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	  Any changes will only be applied once you restart LND.

########################################################################################
"
enter_continue
nano $HOME/parmanode/fulcrum/fulcrum.conf
;;

password|PASSWORD|Password)
echo "
########################################################################################

    Your LND password is NOT a passphrase. It allows you to unlock your wallet.
    .
esac
#option to turn tor on/off

#create lnd wallet

#delete lnd wallet

# $ sudo journalctl -f -u lnd

#lncli getinfo

}