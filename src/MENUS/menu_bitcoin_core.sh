function menu_bitcoin_core {
while true
do
set_terminal_custom "50"
source ~/.parmanode/parmanode.conf >/dev/null #get drive variable

unset running output1 output2 
if ! ps -x | grep bitcoind | grep "bitcoin.conf" >/dev/null 2>&1 ; then running=false ; fi
if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then running=false ; fi 2>/dev/null
if pgrep bitcoind >/dev/null 2>&1 ; then running=true ; fi

if [[ $running != false ]] ; then running=true ; fi

if [[ $running == true ]] ; then
output1="                   Bitcoin is$cyan RUNNING$orange -- see log menu for progress" 

output2="                         (Syncing to the $drive drive)"
else
output1="                   Bitcoin is NOT running -- choose \"start\" to run"

output2="                         (Will sync to the $drive drive)"
fi                         

echo -e "
########################################################################################
                                 ${cyan}Bitcoin Core Menu${orange}                               
########################################################################################
"
echo "$output1"
echo ""
echo "$output2"
echo ""
echo "


      (start)    Start Bitcoind............................................(Do it)

      (stop)     Stop Bitcoind..................(One does not simply stop Bitcoin)

      (restart)  Restart Bitcoind
      
      (cd)       Change syncing drive internal vs external

      (c)        How to connect your wallet...........(Otherwise no point to this)

      (n)        Access Bitcoin node information ....................(bitcoin-cli)
	    
      (log)      Inspect Bitcoin debug.log file .....(Check if Bitcoin is running)

      (bc)       Inspect and edit bitcoin.conf file 

      (dd)       Backup/Restore data directory.................(Instructions only)

      (up)       Set, remove, or change RPC user/pass

      (ai)       Add rpcallowip values to bitcoin.conf........... (Advanced stuff)
      
      (tor)      Tor menu options for Bitcoin

      (bring)    Bring a drive from another Parmanode installation (import)
      
      (ub)       Convert an Umbrel external drive to Parmanode, without 
                 losing Bitcoin data. 
                 
      (ru)       Reverse an Umbrel conversion to Parmanode (ie back to Umbrel)


########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in

start|START|Start)
run_bitcoind
;;

stop|STOP|Stop)
while pgrep bitcoind ; do 
stop_bitcoind 
sleep 2
done

;;

restart|RESTART|Restart)
if [[ $OS == "Linux" ]] ; then sudo systemctl restart bitcoind.service ; fi
if [[ $OS == "Mac" ]] ; then
stop_bitcoind 
run_bitcoind "no_interruption"
fi
;;

cd|CD|Cd)
change_bitcoin_drive
;;

c|C)
connect_wallet_info
continue
;;

n|N)
menu_bitcoin-cli
continue
;;

log|LOG|Log)
log_counter
if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the bitcoin debug.log file in real time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi
set_terminal_wider
tail -f $HOME/.bitcoin/debug.log &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal
continue ;;


bc|BC)
echo "
########################################################################################
    
        This will run Nano text editor to edit bitcoin.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	Any changes will only be applied once you restart Bitcoin.

########################################################################################
"
enter_continue
nano $HOME/.bitcoin/bitcoin.conf
continue
;;

dd|DD)
echo "
########################################################################################
    
                          BACKUP BITCOIN DATA DIRECTORY    

    If you have a spare drive, it is a good idea to make a copy of the bitcoin data 
    directory from time to time. This could save you waiting a long time if you were 
    ever to experience data corruption and needed to resync the blockchain.

    It is VITAL that you stop bitcoind before copying the data, otherwise it will not 
    work correctly when it comes time to use the backed up data, and it's likely the 
    directory will become corrupted. You have been warned.

    You can copy the entire bitcoin_data directory.

    You could also just copy the chainstate directory, which is a lot smaller, and 
    this could be all that you need should there be a chainstate error one day. This 
    directory is smaller and it's more feasible to back it up frequently. I would 
    suggest doing it every 100,000 blocks or so, in addition to having a full copy 
    backed up if you have drive space somewhere.

    To copy the data, use your usual computer skills to copy files. The directory is 
    located either on the internal drive:

                        $HOME/.bitcoin

    or external drive:

                LINUX :   /media/$(whoami)/parmanode/.bitcoin 
                MAC   :   /Volumes/parmanode/.bitcoin

    Note that if you have an external drive for Parmanode, the internal directory 
    $HOME/.bitcoin is actually a symlink (shortcut) to the external 
    directory.

########################################################################################
"
enter_continue
continue
;;

up)
set_rpc_authentication
continue
;;

ai|AI|aI|Ai)
rpcallowip_add
continue
;;

tor|TOR|Tor)
menu_tor_bitcoin
continue
;;

bring|BRING|Bring)
add_drive
;;

ub|UB|Ub)
umbrel_import 
;;

ru|RU|Ru)
umbrel_import_reverse
;;

p|P)
return 1
;;

q|Q|Quit|QUIT)
exit 0
;;

*)
invalid
continue
;;

esac

done
return 0
}

