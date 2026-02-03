function menu_bitcoin { debugf




if ! grep -qE "bitcoin-end" $ic ; then return 0 ; fi

export debuglogfile="$HOME/.bitcoin/debug.log" 

if grep -q "btccombo" $ic >$dn 2>&1 ; then
    dockerbitcoinmenu="\n $pink                          Bitcoin in Docker Container with BTCPay Server $orange"
    btcman="\n\r          $cyan         man)$orange          Explore Bitcoin/BTCPay container (manr for root)"
else
    unset btcman dockerbitcoinmenu
fi

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" $HOME/.parmanode/installed.conf >$dn 2>&1 ; then return 1 ; fi

while true ; do
unset output1 output2 choice external8333 bitcoin_tor_status
source $pc >$dn

if [[ -z $bip110choice ]] ; then
    #should only run once, becauuse bip110choice will be set here.
    bitcoin-cli --version |& grep -q bip110 && bip110choice="BIP110live"
    bitcoin-cli --version |& grep bip110 | grep -q "rc1" && bip110choice="BIP110rc1"
    bitcoin-cli --version |& grep bip110 | grep -q "rc2" && bip110choice="BIP110rc2"
    bitcoin-cli --version |& grep bip110 | grep -q "rc3" && bip110choice="BIP110rc3"
        if [[ -z $bip110choice ]] ; then bip110choice="no_BIP110" 
        fi
    echo "bip110choice=$bip110choice" >> $pc
fi

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


if [[ $OS == "Linux" && $bitcoinrunning == "false" ]] && which bitcoin-qt >$dn 2>&1 ; then
output3="$green                   qtstart)$orange      Start Bitcoin Qt \n"
fi

if [[ $OS == "Linux" && $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >$dn 2>&1 ; then
output3="$red                   qtstop)$orange       Stop Bitcoin Qt \n"
fi

output4="                   Bitcoin Data Usage: $red$(du -shL $HOME/.bitcoin | cut -f1)"$orange

if [[ -z $drive ]] ; then unset output2 ; fi

if [[ $1 == "menu_btcpay" ]] ; then return 0 ; fi

if [[ $bitcoinrunning == "true" ]] && tail -n15 $HOME/.bitcoin/debug.log | grep -qi "Shutdown: In progress" ; then
         output1="                   Bitcoin is$red SHUTTING DOWN$orange -- Please wait"
         output2="                   Will sync to the $drive drive"
fi

debug "bitcoin menu..."
set_terminal 46 100 
if grep -q "disable_bitcoin=true" $pc ; then
         output1="                   Bitcoin is$red DISABLED (type disable to toggle)$orange" 
fi

if [[ $OS != "Mac" ]] ; then
    if ! bitcoin-cli --version |& grep -Eiq "knots|deis" && ! grep bitcoin_ordinalspatch $pc && ! grep -q "disable_bitcoin=true" $pc ; then
        upgradetoknots="${red}\n\n    We are in a war with Core Developers making unwanted changes.
        \r    Please run Knots instead to send them a message to get their head out of their arses.$orange"
    show_knots="$red BITCOIN CORE $yellow(Node, and JPEG relay client)$red"
    else
        show_knots="$green      BITCOIN KNOTS $blue$bip110choice$green"
        unset upgradetoknots
    fi
else
    unset upgradetoknot
    show_knots="$green                  BITCOIN"
fi

get_onion_address_variable bitcoinRPC
if $xsudo test -f $torrc && [[ -n $ONION_ADDR_BITCOINRPC ]] && $xsudo grep -q "8332 127" $torrc ; then
onionRPC="\n$blue    Bitcoin RPC onion address: \n\n    $ONION_ADDR_BITCOINRPC:8332 $orange"
else
unset onionRPC ONION_ADDR_BITCOINRPC
fi


echo -en "
####################################################################################################$cyan
                         $show_knots MENU${orange}    $dockerbitcoinmenu
####################################################################################################
 $upgradetoknots


"
echo -e "       $output1"
echo ""
echo -e "       $output2"
echo ""
echo -e "       $output4"
echo -e ""
if ! ( [[ $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >$dn 2>&1 ) ; then
echo -e "
$green
                   start)$orange        Start Bitcoin $red
                   stop)$orange         Stop Bitcoin $cyan"

    if [[ -n $upgradetoknots ]] ; then
        echo -e "$green$blinkon                   k)            Upgrade to Knots$blinkoff$cyan" 
    fi
    if [[ $bitcoinrunning == "true" ]] ; then
        echo -e "$green                   restart)$orange      Restart Bitcoin"
    fi
fi
echo -e "$output3$red                   disable)$orange      Disable Bitcoin toggle$cyan
                   n)$orange            Access Bitcoin node information $cyan
                   log)$orange          Bitcoin debug.log $cyan
                   bc)$orange           Inspect edit bitcoin.conf file (bcv for vim) $bright_blue
                   dc)$orange           OP_RETURN and datacarrier tweaks...$cyan
                   bcr)$orange          Refresh bitcoin.conf file to Parmanode default $cyan
                   max)$orange          Set max upload target (default 25GB shared per day)$cyan
                   tor)$orange          p2p Tor/I2P menu options for Bitcoin (port 8333)...  $cyan
                   torrpc)$orange       toggle Tor RPC (port 8332) $cyan
                   rpcconnect)$orange   QR scan RPC connection...$cyan
                   mm)$orange           Migrate/Revert an external drive...  $cyan
                   delete)$orange       Delete blockchain data and start over $cyan
                   upd)$orange          Update Bitcoin wizard $cyan
                   tips)$orange         Tips by Parman ...  $btcman $cyan
                   disable)$orange      Toggle on/off (for when manually copying blocks)$cyan
                   o)$orange            OTHER...

$onionRPC

####################################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; clear
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use
;;
endthefed)
grep -q "hide_port_8333" $hm && { gsed -i '/hide_port_8333_message=1/d' $hm >$dn ; continue ; }
echo "hide_port_8333_message=1" >> $hm
;;
1)
test_8333_reachable
please_wait
sleep 5
clear
;;
r)
clear
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

dc)
announce "OP_RETURN is a section in a transaction where arbitrary data can be added. 
    The default limit is 83 bytes for Bitcoin Core (the limit soon to be removed 
    and eventually not changable by the user) and 40 bytes by Bitcoin Knots.

    You can set this to zero, or a number of your choice up to 10000.
    
    Enter a number, or just hit <enter> to go back."

    case $enter_cont in
    "") 
        continue ;;
    0) 
        gsed -i -E '/^datacarrier(size)?=/d' $bc >$dn 2>&1 ; echo "datacarrier=0" | tee -a $bc >$dn 2>&1 ; enter_continue "Done" ;;
    *)
        [[ $enter_cont =~ ^[0-9]+$ ]] || { invalid && continue ; }
        [[ $enter_cont -le 10000 ]] || { invalid && continue ; }
        gsed -i -E '/^datacarrier(size)?=/d' $bc >$dn 2>&1 ; echo "datacarrier=1" | tee -a $bc >$dn 2>&1 
        echo "datacarriersize=$enter_cont" | tee -a $bc >$dn 2>&1 
        ;;
    esac
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
max)
    announce "You can set the maximum amount of data that your node will upload to others
    for the specific purpose of helping them download the blockchain. This does not 
    include mempool transaction data.

    For unlimited, use '0'.

    Any value you enter is in MiB.
    
    Hit <enter> alone for the default, which is 25000 Mib (~24.4 GiB)."
    jump $enter_cont

    case $enter_cont in 
    "") 
    gsed -i 's/maxuploadtarget=.*$/maxuploadtarget=25000/' $bc >$dn 2>&1 
    success "Maxuploadtarget set to 25000 MiB (25 GiB)"
    ;;
    0)
    gsed -i '/maxuploadtarget=.*$/d' $bc >$dn 2>&1
    success "Maxuploadtarget set to unlimited"
    ;;
    esac

    [[ $enter_cont =~ ^[0-9]+$ ]] || { invalid ; continue ; }

    case $enter_cont in
    *)
    grep -q "maxuploadtarget=" $bc || {
        echo "maxuploadtarget=$enter_cont" | $xsudo tee -a $bc >$dn 2>&1
        success "Maxuploadtarget set to $enter_cont MiB"
        continue
        
    }
    gsed -i "s/maxuploadtarget=.*$/maxuploadtarget=$enter_cont/" $bc >$dn 2>&1
    success "Maxuploadtarget set to $enter_cont MiB"
    ;;
    esac
;;


bcr|BCR|Bcr)
yesorno  "Are you sure you want to refresh bitcoin.conf? 
    
    Maybe back it up first. Also, you will lose your Tor/i2P settings, make sure 
    to re-select them from the bitcoin-tor menu." || continue

make_bitcoin_conf refresh && gsed -i '/bitcoiin_tor_status/d' $pc >$dn 2>&1 && success "bitcoin.conf refreshed to Parmanode default"
continue
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
k)
if [[ -n $upgradetoknots ]] ; then
upgrade_to_knots
fi
;;

vbc|bcv)
vim_warning
vim $HOME/.bitcoin/bitcoin.conf
;;

tor|TOR|Tor)
menu_bitcoin_tor
continue
;;

torrpc|rpctor)
toggle_bitcoin_rpc_tor
;;

rpcconnect)
bitcoin_rpcconnect
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
disable)
toggle_disable_bitcoin
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

function bitcoin_status { debugf
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

if [[ $running_text =~ ^AddLocal.* ]] ; then 
   export running_text="(refresh for status)" 
fi
}






function bitcoin_rpcconnect { debugf


yesorno "This will expose your Bitcoin connection credentials to the screen via QR and text. 
    
    Proceed?" || return 1
source $bc

if ! which qrencode >$dn 2>&1 ; then install_qrencode || return 1 ; fi

thestring="http://$rpcuser:$rpcpassword@$ONION_ADDR_BITCOINRPC:8332"
theclearnetstring="http://$rpcuser:$rpcpassword@$IP:8332"

get_onion_address_variable bitcoinRPC
if $xsudo test -f $torrc && [[ -n $ONION_ADDR_BITCOINRPC ]] && $xsudo grep -q "8332 127" $torrc ; then
announce "

The tor connection...
$cyan
$thestring

$(qrencode -t ansiutf8 $thestring)

$orange
The next screen will show clearnet
"
fi

announce "

The clearnet connection...
$cyan
    $theclearnetstring

$(qrencode -t ansiutf8 $theclearnetstring)
$orange
"


}