function menu_yield_generator {

#grep "setting onion hostname to" ./yg_privacy.log | tail -n1 | grep -oE 'hostname to :.+$'

while true ; do

if [[ -e $jmcfg ]] && sudo gsed -nE '/^ordertype =/p' $jmcfg | grep -q absoffer ; then 
ordertype=a 
else 
ordertype=r 
fi

if [[ -e $logfile ]] ; then    

    nick="${bright_blue}$(cat $logfile | grep "Sending this handshake" | grep "nick" | tail -n1 | grep -oE '"nick":.*,' | cut -d \" -f4)${orange}"
    debug "nick is $nick"
    ygs="
    Yield Generator Settings:
    $green
            \r        $(sudo gsed -nE '/^ordertype =/p' $jmcfg)
            \r        $(sudo gsed -nE "/cjfee_$ordertype.=/p" $jmcfg)
            \r        $(sudo gsed -n '/cjfee_factor =/p' $jmcfg)
            \r        $(sudo gsed -n '/minsize =/p' $jmcfg)
            \r        $(sudo gsed -n '/size_factor =/p' $jmcfg)

    $orange
    "

    #For onion address
    grep "setting onion hostname to" $jmcfg | tail -n1 | cut -d : -f 2

fi

#if grep "setting onion hostname to" $logfile ; then
if docker exec joinmarket ps ax | grep yg-privacyenhanced.py | grep -vq bash ; then
    wallet=$(docker exec joinmarket ps ax | grep yg-privacyenhanced.py | grep -v bash | awk '{print $7}' | gsed -nE 's|\/.+\/||p')
    ygtext="    Yield Generator is:    $green   RUNNING$orange with wallet$magenta $wallet"
    
    if docker exec joinmarket ps ax | grep obwatch | grep -q python ; then
        if [[ -n $nick ]] ; then
            orderbooknn="\n\r    Orderbookd Nickname is:   ${bright_blue}refresh later to see$orange"
        else
            orderbooknn="\n\r    Orderbookd Nickname is:   $nick"
            ygrunning="true"
        fi
    fi
else
    ygtext="    Yield Generator is$red   NOT RUNNING$orange"
    unset orderbooknn
    unset ygrunning
fi

if  [[ $wallet != "NONE" ]] && ( tail -n1 $logfile | grep -qi "locked by pid" || tail -n1 $logfile | grep -qi "Failed to load wallet" ) ; then
    announce "Some issue with loading wallet. See log for information."
    ygtext="    Yield Generator is$red   NOT RUNNING$orange"
    unset orderbooknn
    unset ygrunning
fi

set_terminal_custom 48 ; echo -ne "
########################################################################################

                                   YEILD GENERATOR                         $cyan
                              Be a coinjoin market maker                   $orange

########################################################################################


$ygtext
$orderbooknn

$green
                start)$orange    Start Yield Generator 
$red
                stop)$orange     Start Yield Generator 
$yellow
                c)$orange        Configure Yeild Generator Settings...
$cyan
                flog)$orange     Follow Yield Generator log as it populates
$cyan
                log)$orange      Read Yield Generator log with the (logv for vim)
$cyan
                del)$orange      Delete lockfile ... 

$ygs
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;;

start)
start_yield_generator
;;

stop)
stop_yield_generator
;;

log)
   check_wallet_loaded || continue
   announce "Hint: Use q to exit the view screen"
   sudo less $logfile
;;
logv)
   check_wallet_loaded || continue
   vim_warning ; sudo vim $logfile
;; 
flog)
    check_wallet_loaded || continue
    yield_generator_log || { enter_continue "some error" ; return 1 ; }
;;
c)
    configure_yg 
;;
del)
    delete_lockfile
    sudo rm $logfile
;;
*)
    invalid
;;
esac
done
}


function yield_generator_log {

log_counter
if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the log file in real-time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi
set_terminal_wider
tail -f $logfile &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
return 
}

function start_yield_generator {
    if [[ -n $ygrunning ]] ; then announce "Already running" ; continue ; fi
    check_wallet_loaded || return
    
    silentecho=true
    set_terminal
    announce "Please enter the password (lock) for $wallet - keystrokes will not show" 
    unset silentecho

    password=$enter_cont
    docker exec -d joinmarket bash -c "echo $password | /jm/clientserver/scripts/yg-privacyenhanced.py /root/.joinmarket/wallets/$wallet | tee /root/.joinmarket/yg_privacy.log" || enter_continue "Some error with wallet: $wallet"
    unset password enter_cont
    sleep 1

}

function stop_yield_generator {
    yg_PID=$(docker exec joinmarket ps ax | grep privacyenhanced.py | grep -v bash | awk '{print $1}')
    docker exec joinmarket kill -SIGTERM $yg_PID
    sudo rm $logfile 2>&1
}