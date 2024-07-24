from tools.screen_f import *


def menu_bitcoin():



#isbitcoinrunning
    output1=f"                   Bitcoin is{green} RUNNING{orange} {running_text}"
    output2=f"                   Sync'ing to the {drive} drive"
    stop=f"{red}"
    output1=f"                   Bitcoin is{red} NOT running{orange} -- choose \"start\" to run"
    output2=f"                   Will sync to the {drive} drive"
    start=f"{green}"

#    output4=f"""                   Bitcoin Data Usage: {red}$(du -shL $HOME/.bitcoin | cut -f1)"{orange}"""

    print(f"""{orange}
########################################################################################
                                {cyan}Bitcoin Core Menu{orange}                               
########################################################################################

{output1}

{output2}"

{start}
      (start){orange}    Start Bitcoind............................................(Do it)

      (stop)     Use your mouse to close the Bitcoin window
{cyan}
   More options coming soon...

{orange}
########################################################################################
""")

# {orange}
#       (n)        Access Bitcoin node information ....................(bitcoin-cli)

#       (bc)       Inspect and edit bitcoin.conf file 

#       (up)       Set, remove, or change RPC user/pass
# {bright_blue}
#       (tor){orange}      Tor menu options for Bitcoin...

#       (mm)       Migrate/Revert an external drive...

#       (delete)   Delete blockchain data and start over (eg if data corrupted)

#       (update)   Update Bitcoin wizard
# {output3}
#       (o)        OTHER...


# ########################################################################################
# "
choose "xpmq"
echo -e "{red}{blinkon}
 Hit 'r' to refresh menu {blinkoff}
 {orange}"
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
elif tail -n1 $HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$' ; then
export running_text="$($HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$')"
elif tail -n2 $HOME/.bitcoin/debug.log | grep -q "thread start" >/dev/null 2>&1 ; then
export 
running_text="$($HOME/.bitcoin/debug.log | grep -Eo '\s.*$')" >/dev/null
#elif ... Waiting 300 seconds before querying DNS seeds
else 
export running_text="-- status ...type r to refresh, or see log"
fi

if [[ -n $height ]] ; then
    if tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -qE 'progress=1.00' >/dev/null 2>&1 ; then
    export running_text="-- height=$height (fully sync'd)"
    else
    temp=$(tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'progress=0\.[0-9]+\s' | cut -d \. -f 2)
    export pc="${temp:0:2}.${temp:2:2}%"
    if [[ $pc == "00.00%" ]] ; then pc='' ; fi
    export running_text="-- height=$height ($pc)"
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
