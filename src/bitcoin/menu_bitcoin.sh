function menu_bitcoin {

export debuglogfile="$HOME/.bitcoin/debug.log" 

if grep -q "btccombo" < $ic ; then
dockerbitcoinmenu=" $pink                Bitcoin in Docker Container with BTCPay Server $orange"
fi

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" < $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then return 1 ; fi
while true
do
unset start stop output1 output2 highlight 
if [[ -e $debuglogfile ]] && tail -n 25 $debuglogfile | grep -q "Corrupt" ; then
announce "Parmanode has detected a potential serious error from the Bitcoin log.
    You should take a look, and make a decision - I can't diagnose all potential
    problems with this program. One option might be to re-index the chain (do
    look that up if needed), another may be to delete the data and start over - 
    there's a Parmanode menu option for that.
    
    A couple of times this happened to me, and the old 'turn it off and and again'
    trick did the trick."
fi

clear

bitcoin_status #get running text variable.
isbitcoinrunning 
   if [[ -e $debuglogfile ]] && tail $debuglogfile | grep -q "Shutdown: done" ; then bitcoinrunning="false" ; fi

source $oc
if [[ $bitcoinrunning != "false" ]] ; then running="true" ; fi
if [[ $bitcoinrunning == "true" ]] ; then
output1="                   Bitcoin is$green RUNNING$orange $running_text"
output2="                   Sync'ing to the $drive drive"
highlight="$reset"
stop="$red"
else
output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"

output2="                   Will sync to the $drive drive"
start="$green"
fi                         


if [[ $OS == Linux && $bitcoinrunning == "false" ]] ; then
output3="
$green      (qtstart)$orange  Start Bitcoin Qt
"
fi

if [[ $OS == Linux && $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >/dev/null 2>&1 ; then
output3="
$red      (qtstop)$orange   Stop Bitcoin Qt
"
fi

output4="                   Bitcoin Data Usage: $red$(du -shL $HOME/.bitcoin | cut -f1)"$orange

if [[ -z $drive ]] ; then unset output2 ; fi

if [[ $1 == menu_btcpay ]] ; then return 0 ; fi
debug "bitcoin menu..."
set_terminal_custom "52"

echo -en "
########################################################################################
                                ${cyan}Bitcoin Core Menu${orange}                               
$dockerbitcoinmenu
########################################################################################


"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "$output4"
echo ""
echo -ne "
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

      (update)   Update Bitcoin wizard
$output3
      (o)        OTHER...


########################################################################################
"
choose "xpmq"
echo -e "$red$blinkon
 Hit 'r' to refresh menu $blinkoff
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
if ! grep -q "btccombo" < $ic && [[ $OS == Mac ]] ; then no_mac ; continue ; fi

menu_bitcoin_cli
continue
;;

log|LOG|Log)
log_counter
if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the bitcoin debug.log file in real-time as it populates.
    
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

update|Update|UPDATE)
update_bitcoin
continue
;;

o|O)
menu_bitcoin_other || return 1
;;

qtstart)
if [[ -n $output3 && $bitcoinrunning == "false" ]] ; then
run_bitcoinqt
fi
;;

qtstop)
if [[ -n $output3 && $bitcoinrunning == "true" ]] ; then
stop_bitcoinqt
fi
;;

p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
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

function bitcoin_status {
if [[ ! -e $HOME/.bitcoin/debug.log ]] ; then return 1 ; fi
source ~/.parmanode/parmanode.conf >/dev/null 2>&1 #get drive variable
unset running output1 output2 highlight height running_text

# #get bitcoin block number
# source $bc
# curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/ >/tmp/result 2>&1
# gbci=$(cat /tmp/result | grep -E ^{ | jq '.result')

# #bitcoin finished?
# bsync=$(echo $gbci | jq -r ".initialblockdownload") #true or false

export height="$(tail -n 200 $HOME/.bitcoin/debug.log | grep version | grep height= | tail -n1 | grep -Eo 'height=[0-9]+\s' | cut -d = -f 2 | tr -d ' ')" 
#set $running_text

if [[ -n $height ]] ; then
export running_text="-- height=$height"
elif tail -n1 $HOME/.bitcoin/debug.log | grep -Eq 'Verification progress: .*$' ; then
export running_text="$( tail -n1 $HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$')"
elif tail -n2 $HOME/.bitcoin/debug.log | grep -q "thread start" >/dev/null 2>&1 ; then
export running_text="$(tail -n2 $HOME/.bitcoin/debug.log | grep -Eo '\s.*$')" >/dev/null
#elif ... Waiting 300 seconds before querying DNS seeds
else 
export running_text="-- status ...type r to refresh, or see log"
fi

if [[ -n $height ]] ; then
    if tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -qE 'progress=1.00' >/dev/null 2>&1 ; then
    export running_text="-- height=$height (fully sync'd)"
    else
    temp=$(tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'progress=0\.[0-9]+\s' | cut -d \. -f 2)
    export PC="${temp:0:2}.${temp:2:2}%"
    if [[ $PC == "00.00%" ]] ; then PC='' ; fi
    export running_text="-- height=$height ($PC)"
    fi
fi

if tail -n1 $HOME/.bitcoin/debug.log | grep -qEo 'Pre-synchronizing blockheaders' ; then
export running_text="-- Pre-synchronizing blockheaders"
return 0
fi

if tail -n1 $HOME/.bitcoin/debug.log | grep -qEo "Synchoronizing blockheaders" ; then
export running_text="Synchronizing blockheaders"
return 0
fi
}


