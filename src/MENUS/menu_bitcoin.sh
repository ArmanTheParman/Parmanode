function menu_bitcoin {

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" < $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then return 1 ; fi

while true
do
unset start stop output1 output2 highlight 
if tail -n 25 $HOME/.bitcoin/debug.log | grep -q "Corrupt" ; then
announce "Parmanode has detected a potential serious error from the Bitcoin log.
    You should take a look, and make a decision - I can't diagnose all potential
    problems with this program. One option might be to re-index the chanin (do
    look that up if needed), another may be to delete the data and start over - 
    there's a Parmanode menu option for that."
fi


set_terminal_custom "52"

menu_bitcoin_status

isbitcoinrunning

if [[ $running != false ]] ; then running=true ; fi

if [[ $running == true ]] ; then
output1="                   Bitcoin is$green RUNNING$orange $running_text"

output2="                   Sync'ing to the $drive drive"
highlight="$reset"
stop="$red"
else
output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"

output2="                   Will sync to the $drive drive"
start="$green"
fi                         

# #This causes error output when bitcoin loading
# if [[ $OS == Linux && $running == true ]] ; then
# blockheight=$(bitcoin-cli getblockchaininfo | grep blocks | grep -Eo '[0-9]*' > $dp/blockheight 2>/dev/null) &
# fi

clear
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
$start
      (start)$orange    Start Bitcoind............................................(Do it)

      (stop)     Stop Bitcoind..................(One does not simply stop Bitcoin)

      (restart)  Restart Bitcoind
      
      (n)        Access Bitcoin node information ....................(bitcoin-cli)
$highlight    
      (log)$orange      Bitcoin debug.log ...............(see details of bitcoin running)

      (bc)       Inspect and edit bitcoin.conf file 

      (up)       Set, remove, or change RPC user/pass
$bright_blue
      (tor)$orange      Tor menu options for Bitcoin...

      (mm)       Migrate/Revert an external drive...

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
menu_bitcoin || return 1
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

c|C)
connect_wallet_info
continue
;;

n|N)
if [[ $OS == Mac ]] ; then no_mac ; continue ; fi

menu_bitcoin_cli
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

up)
set_rpc_authentication
continue
;;

tor|TOR|Tor)
menu_bitcoin_tor
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
stop_bitcoind
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

function menu_bitcoin_status {
source ~/.parmanode/parmanode.conf >/dev/null 2>&1 #get drive variable
unset running output1 output2 highlight height running_text

export height=$(tail -n200 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'height=[0-9]+\s' | cut -d = -f 2 | tr -d ' ') >/dev/null 2>&1
#set $running_text
if [[ -n $height ]] ; then
export running_text="-- height=$height"
elif tail -n1 $HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$' ; then
export running_text="$($HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$')"

elif tail -n2 $HOME/.bitcoin/debug.log | grep "thread start" ; then
export running_text="$($HOME/.bitcoin/debug.log | grep -Eo '\s.*$')"
#elif ... Waiting 300 seconds before querying DNS seeds
else export running_text="-- status ...type r to refresh, or see log" 
fi

if [[ -n $height ]] ; then
    if tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -E 'progress=1.00' >/dev/null 2>&1 ; then
    export running_text="-- height=$height (fully sync'd)"
    else
    temp=$(tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'progress=0\.[0-9]+\s' | cut -d \. -f 2)
    export pc="${temp:0:2}.${temp:2:2}%"
    if [[ $pc == "00.00%" ]] ; then pc='' ; fi
    export running_text="-- height=$height ($pc)"
    fi
fi

if tail -n1 $HOME/.bitcoin/debug.log | grep -Eo 'Pre-synchronizing blockheaders' ; then
export running_text="-- Pre-synchronizing blockheaders"
return 0
fi

if tail -n1 $HOME/.bitcoin/debug.log | grep -Eo "Synchoronizing blockheaders" ; then
export running_text="Synchronizing blockheaders"
return 0
fi
}