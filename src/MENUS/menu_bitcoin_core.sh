function menu_bitcoin_core {

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" < $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then return 1 ; fi

while true
do

if tail -n 25 $HOME/.bitcoin/debug.log | grep -q "Corrupt" ; then
announce "Parmanode has detected a potential serious error from the Bitcoin log.
    You should take a look, and make a decision - I can't diagnose all potential
    problems with this program. One option might be to re-index the chanin (do
    look that up if needed), another may be to delete the data and start over - 
    there's a Parmanode menu option for that."
fi


set_terminal_custom "52"
source ~/.parmanode/parmanode.conf >/dev/null 2>&1 #get drive variable
unset running output1 output2 highlight 

height=$(tail -n200 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'height=[0-9]+\s' | cut -d = -f 2 | tr -d ' ') >/dev/null 2>&1
#set $running_text
if [[ -n $height ]] ; then
running_text="-- height=$height"
elif tail -n1 $HOME/.bitcoin/debug.log | grep -Eo "Verification progress: .*$" ; then
running_text="$($HOME/.bitcoin/debug.log | grep -Eo "Verification progress: .*$")"
elif tail -n2 $HOME/.bitcoin/debug.log | grep "thread start" ; then
running_text="$($HOME/.bitcoin/debug.log | grep -Eo '\s.*$')"
#elif ... Waiting 300 seconds before querying DNS seeds
else running_text="-- status ...type r to refresh, or see log" 
fi

if [[ -n $height ]] ; then
    if tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -E 'progress=1.00' >/dev/null 2>&1 ; then
    running_text="-- height=$height (fully sync'd)"
    else
    temp=$(tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'progress=0\.[0-9]+\s' | cut -d \. -f 2)
    pc="${temp:0:2}.${temp:2:2}%"
    running_text="-- height=$height ($pc)"
    fi
fi


if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >/dev/null ; then running=true ; else running=false ; fi
else
    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >/dev/null 2>&1 ; then running=false ; fi
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then running=false ; fi 2>/dev/null
    if pgrep bitcoind >/dev/null 2>&1 ; then running=true ; fi
fi


if [[ $running != false ]] ; then running=true ; fi

if [[ $running == true ]] ; then
output1="                   Bitcoin is$green RUNNING$orange $running_text"

output2="                   Sync'ing to the $drive drive"
highlight="$green"
else
output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"

output2="                   Will sync to the $drive drive"
fi                         

# #This causes error output when bitcoin loading
# if [[ $OS == Linux && $running == true ]] ; then
# blockheight=$(bitcoin-cli getblockchaininfo | grep blocks | grep -Eo '[0-9]*' > $dp/blockheight 2>/dev/null) &
# fi


echo -e "
########################################################################################
                                 ${cyan}Bitcoin Core Menu${orange}                               
########################################################################################

"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "

      (start)    Start Bitcoind............................................(Do it)

      (stop)     Stop Bitcoind..................(One does not simply stop Bitcoin)

      (restart)  Restart Bitcoind
      
      (n)        Access Bitcoin node information ....................(bitcoin-cli)
$highlight    
      (log)$orange      Bitcoin debug.log ...............(see details of bitcoin running)

      (bc)       Inspect and edit bitcoin.conf file 

      (up)       Set, remove, or change RPC user/pass

      (tor)      Tor menu options for Bitcoin

      (mm)       Migrate/Revert an external drive.

      (delete)   Delete blockchain data and start over (eg if data corrupted)

      (o)        OTHER...

########################################################################################
"
choose "xpmq"
echo -e "$red
 Hit 'r' to refresh menu 
 $orange"
read choice
set_terminal

case $choice in
r)
menu_bitcoin_core
;;

m|M) back2main ;;


start|START|Start)
run_bitcoind
;;

stop|STOP|Stop)
if [[ $OS == Linux ]] ; then
    while pgrep bitcoind ; do 
    stop_bitcoind 
    sleep 2
    done
elif [[ $OS == Mac ]] ; then
    stop_bitcoind
fi

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
continue ;;

RU|Ru)
    umbrel_import_reverse
    ;;

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
    work correctly when it comes time toRU|Ru)
    umbrel_import_reverse
    ;; use the backed up data, and it's likely the 
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

tor|TOR|Tor)
menu_tor_bitcoin
continue
;;

mm|MM|Mm|migrate|Migrate)
menu_migrate
continue
;;

o|O)
menu_bitcoin_other || return 1
;;

p|P)
menu_use
;;

delete|Delete|DELETE)
delete_blockchain
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

