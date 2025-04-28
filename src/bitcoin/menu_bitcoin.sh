function menu_bitcoin {

if ! grep -qE "bitcoin-end" $ic ; then return 0 ; fi
export debuglogfile="$HOME/.bitcoin/debug.log" 

if grep -q "btccombo" $ic >$dn 2>&1 ; then
dockerbitcoinmenu=" $pink                Bitcoin in Docker Container with BTCPay Server $orange"
btcman="$cyan      man)$orange          Explore Bitcoin/BTCPay container (manr for root)"
else
unset btcman dockerbitcoinmenu
fi

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" $HOME/.parmanode/installed.conf >$dn 2>&1 ; then return 1 ; fi

while true ; do
unset output1 output2 choice external8333 bitcoin_tor_status
source $pc >$dn

#Might bring this back later, causing too much confustion
# grep -q hide_port_8333 $hm || {
# if    [[ $bitcoin_tor_status == t || $bitcoin_tor_status == tonlyout ]] ; then
#     external8333="${blue}Node is NOT reachable to the world via port 8333 due to TOR status$orange hit 1 to refresh"
# elif  grep -q "_8333reachable=true" $pc ; then
#     external8333="${green}Node is reachable to the world via port 8333$orange hit 1 to refresh"
# else
#     external8333="${red}Node is NOT reachable via port 8333.$orange hit 1 to refresh$red
# Requires port forwarding on your router - Parman can be hired to help.
# endthefed to hide this message.$orange"
# fi
# }

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

if [[ $bitcoinrunning != "false" ]] ; then running="true" ; fi
if [[ $bitcoinrunning == "true" ]] ; then

output1="                   Bitcoin is$green RUNNING$orange $running_text"
output2="                   Sync'ing to the $drive drive"
    if tail -n20 $HOME/.bitcoin/debug.log | grep -iq "shutdown in progress" ; then
    output1="                   Bitcoin is$bright_blue SHUTTING DOWN$orange"
    fi
    if tail -n1 $HOME/.bitcoin/debug.log | grep -iq "Shutdown: done" ; then
         output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"
         output2="                   Will sync to the $drive drive"
    fi

else
output1="                   Bitcoin is$red NOT running$orange -- choose \"start\" to run"

output2="                   Will sync to the $drive drive"
fi                         


if [[ $OS == Linux && $bitcoinrunning == "false" ]] && which bitcoin-qt >$dn 2>&1 ; then
output3="\n$green               qtstart)$orange      Start Bitcoin Qt \n"
fi

if [[ $OS == Linux && $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >$dn 2>&1 ; then
output3="\n$red               qtstop)$orange       Stop Bitcoin Qt \n"
fi

output4="                   Bitcoin Data Usage: $red$(du -shL $HOME/.bitcoin | cut -f1)"$orange

if [[ -z $drive ]] ; then unset output2 ; fi

if [[ $1 == "menu_btcpay" ]] ; then return 0 ; fi

if [[ $bitcoinrunning == "true" ]] && tail -n15 $HOME/.bitcoin/debug.log | grep -qi "Shutdown: In progress" ; then
         output1="                   Bitcoin is$red SHUTTING DOWN$orange -- Please wait"
         output2="                   Will sync to the $drive drive"
fi

debug "bitcoin menu..."
set_terminal 52 88
if grep -q "disable_bitcoin=true" $pc ; then
         output1="                   Bitcoin is$red DISABLED$orange" 
fi


echo -en "
########################################################################################
                                ${cyan}Bitcoin Menu${orange}                               
$dockerbitcoinmenu
########################################################################################

"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "$output4"
echo -e ""
if ! ( [[ $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >$dn 2>&1 ) ; then
echo -ne "
$green
               start)$orange        Start Bitcoin
            $red
               stop)$orange         Stop Bitcoin
            $cyan"

    if [[ $bitcoinrunning == "true" ]] ; then
        echo -ne "
               restart)$orange      Restart Bitcoin \n"
    fi
fi
echo -ne "$output3 $cyan
               n)$orange            Access Bitcoin node information 
            $cyan
               log)$orange          Bitcoin debug.log 
            $cyan
               bc)$orange           Inspect edit bitcoin.conf file (bcv for vim)
            $cyan
               up)$orange           Set, remove, or change RPC user/pass
            $bright_blue
               tor)$orange          Tor menu options for Bitcoin...
            $cyan
               mm)$orange           Migrate/Revert an external drive...
            $cyan
               delete)$orange       Delete blockchain data and start over
            $cyan
               upd)$orange          Update Bitcoin wizard
            $cyan
               tips)$orange         Tips by Parman ...
         $btcman
         $cyan      o)$orange            OTHER...

                                                         
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use
;;
endthefed)
grep -q "hide_port_8333" $hm && { sed -i '/hide_port_8333_message=1/d' $hm >$dn ; continue ; }
echo "hide_port_8333_message=1" >> $hm
;;
1)
test_8333_reachable
please_wait
sleep 5
set_terminal
;;
r)
set_terminal
continue
;;

m|M) back2main ;;

start|START|Start)
start_bitcoin
;;

stop|STOP|Stop)
stop_bitcoin
;;

restart|RESTART|Restart)
stop_bitcoin
start_bitcoin 
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
enter_continue ; jump $enter_cont
fi
set_terminal 38 200

if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
tmux attach-session -t bitcoin_log 2>/dev/null || {
    tmux new -s bitcoin_log "tail -f $HOME/.bitcoin/debug.log"
    }
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
enter_continue ; jump $enter_cont
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

upd)
update_bitcoin
continue
;;

o|O)
menu_bitcoin_other || return 1
;;

qtstart)
if [[ -n $output3 && $bitcoinrunning == "false" ]] ; then
start_bitcoinqt
fi
;;

qtstop)
if [[ -n $output3 && $bitcoinrunning == "true" ]] ; then
stop_bitcoinqt
fi
;;

delete|Delete|DELETE)
stop_bitcoin
delete_blockchain
return 1
;;

man)
menu_btcpay_man
;;
manr)
menu_btcpay_manr
;;
tips)
bitcoin_tips
;;
"")
continue ;;
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
source ~/.parmanode/parmanode.conf >$dn 2>&1 #get drive variable
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
    if tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -qE 'progress=1.00' >$dn 2>&1 ; then
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




function bitcoin_tips {
set_terminal_high ; echo -e "
########################################################################################$cyan
                          Parmanode Bitcoin Usage Tips$orange
########################################################################################


    It's nice to see what Bitcoin is up to in real time. Check out the log from the
    menu. If the log menu is playing up, you can look at it manually with $cyan
    nano $HOME/.bitcoin/debug.log$orange

    The information like the block height is captured from the debug.log file. It can
    glitch, no big deal, you can just look at the log and read the progress. The
    file populates with the newest additions at the bottom. When you see$cyan
    progress=1.00000000$orange, you know it's fully synced.

    If you have data corruption, Bitcoin will fail to start. Read the log file and 
    see if it indicates data corruption - you'll have to delete and resync. Parmanode
    Bitcoin menu has a tool for that.

    If you are having trouble starting/stopping bitcoin, you can try doing it manually.
    In Mac, use the GUI - click the icon in the Applications menu. In Linux, do$cyan 
    sudo systemctl COMMAND bitcoind$orange. Replace COMMAND with start, stop, restart, 
    or status.
    
    In you're using the BTCPay combo docker container, restarting the container 
    manually will be problematic, because the numerous programs do not automatically 
    load up if the container is simply restarted. Instead, you can manually enter the 
    container, do$cyan pkill -15 bitcoind$orange, and restart it with
    
        $cyan bitcoind -conf=/home/parman/.bitcoin/bitcoin.conf$orange

    If you want to move the data directory somewhere else, first have a look at the
    ${cyan}dfat$orange menu option in Parmanode-->Tools, and glean from there how the symlinks
    work. To move or copy the data directory, make sure Bitcoin has been stopped. Then
    use the$cyan rysync$orange tool from the Parmanode-->Tools menu. It will help you 
    construct the correct command.


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
return 0 
;;
esac

}
