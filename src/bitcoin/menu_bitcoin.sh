function menu_bitcoin {

export debuglogfile="$HOME/.bitcoin/debug.log" 

if grep -q "btccombo" $ic ; then
dockerbitcoinmenu=" $pink                Bitcoin in Docker Container with BTCPay Server $orange"
fi

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then return 1 ; fi

while true ; do

unset output1 output2 choice

if [[ -e $debuglogfile ]] && tail -n50 $debuglogfile | grep -q "Corrupt" ; then

    printthis="\r$(cat $debuglogfile | grep -n "Corrupt" | tail -n1)"
   
    announce "Parmanode has detected a potential serious error from the Bitcoin log.
    This notification was detected by the following line found in bitcoin's
    debug.log file. It coult be a false positive. Take a look...
    $red
    $printthis
    $orange
    One option might be to re-index the chain (do look that up if needed), 
    another may be to delete the data and start over - there's a Parmanode menu 
    option for that.

    Another option might be to try  the old 'off and on again' trick.

    A couple of times this happened to me, and the old 'turn it off and and again'
    trick did the trick."
fi

bitcoin_status #get running text variable.
isbitcoinrunning 
   if [[ -e $debuglogfile ]] && tail $debuglogfile | grep -q "Shutdown: done" ; then bitcoinrunning="false" ; fi

source $oc
if [[ $bitcoinrunning != "false" ]] ; then running="true" ; fi
if [[ $bitcoinrunning == "true" ]] ; then
output1="                   Bitcoin is$green RUNNING$orange $running_text"
output2="                   Sync'ing to the $drive drive"
else
output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"

output2="                   Will sync to the $drive drive"
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
$green
      (start)$orange    Start Bitcoind............................................(Do it)
$red
      (stop)$orange     Stop Bitcoind..................(One does not simply stop Bitcoin)
$cyan
      (restart)$orange  Restart Bitcoind
$cyan
      (n)$orange        Access Bitcoin node information ....................(bitcoin-cli)
$cyan
      (log)$orange      Bitcoin debug.log ...............(see details of bitcoin running)
$cyan
      (bc)$orange       Inspect and edit bitcoin.conf file (bcv for vim)
$cyan
      (up)$orange       Set, remove, or change RPC user/pass
$bright_blue
      (tor)$orange      Tor menu options for Bitcoin...
$cyan
      (mm)$orange       Migrate/Revert an external drive...
$cyan
      (delete)$orange   Delete blockchain data and start over (eg if data corrupted)
$cyan
      (update)$orange   Update Bitcoin wizard
$output3
$cyan      (o)$orange        OTHER...

                                                               $red hit 'r' to refresh $orange
########################################################################################
"
choose "xpmq"
read choice
set_terminal

case $choice in
r)
set_terminal
continue
;;

m|M) back2main ;;

start|START|Start)
start_bitcoin
;;

stop|STOP|Stop)
if [[ $OS == Linux ]] ; then
    while pgrep bitcoind ; do 
    stop_bitcoin
    sleep 2
    done
elif [[ $OS == Mac ]] ; then
    stop_bitcoin
fi

;;

restart|RESTART|Restart)
if [[ $OS == "Linux" ]] ; then sudo systemctl restart bitcoind.service ; fi
if [[ $OS == "Mac" ]] ; then
stop_bitcoin
start_bitcoin "no_interruption"
fi
;;

c|C)
connect_wallet_info
continue
;;

n|N)
if ! grep -q "btccombo" $ic && [[ $OS == Mac ]] ; then no_mac ; continue ; fi

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

if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and to that?" || continue
fi
TMUX2=$TMUX ; unset TMUX 
tmux new -s -d "tail -f $HOME/.bitcoin/debug.log"
TMUX=$TMUX2

continue ;;

RU|Ru)
    umbrel_import_reverse
    ;;

bc|BC)
echo -e "
########################################################################################
    
        This will run$cyan Nano$orange text editor to edit bitcoin.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

        Any changes will only be applied once you restart Bitcoin.

########################################################################################
"
enter_continue
nano $HOME/.bitcoin/bitcoin.conf
continue
;;
bcv)
vim_warning
vim $HOME/.bitcoin/bitcoin.conf
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
stop_bitcoin
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
unset running output1 output2 height running_text

export height="$(tail -n 200 $HOME/.bitcoin/debug.log | grep version | grep height= | tail -n1 | grep -Eo 'height=[0-9]+\s' | cut -d = -f 2 | tr -d ' ')" 
#set $running_text

if [[ -n $height ]] ; then
export running_text="-- height=$height"
elif tail -n1 $HOME/.bitcoin/debug.log | grep -Eq 'Verification progress: .*$' ; then
export running_text="$( tail -n1 $HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$')"
elif tail -n2 $HOME/.bitcoin/debug.log | grep -q "thread start" ; then
export running_text="$(tail -n2 $HOME/.bitcoin/debug.log | grep -Eo '\s.*$')" 
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


