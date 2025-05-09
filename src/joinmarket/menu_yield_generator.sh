function menu_yield_generator {
if ! grep -q "joinmarket-end" $ic ; then return 0 ; fi
#grep "setting onion hostname to" ./yg_privacy.log | tail -n1 | grep -oE 'hostname to :.+$'

while true ; do

if [[ -e $jmcfg ]] && sudo gsed -nE '/^ordertype =/p' $jmcfg | grep -q absoffer ; then 
ordertype=a 
else 
ordertype=r 
fi

########################################################################################
# Yield generator settins printing ($ygs)
########################################################################################
if [[ -e $logfile ]] ; then    

    nick="${bright_blue}$(cat $logfile | grep "Sending this handshake" | grep "nick" | tail -n1 | grep -oE '"nick":.*,' | cut -d \" -f4)${orange}"
    debug "nick is $nick"
    ygs="

                           _______________________________
                           |  Yield Generator Settings:  |
                           |                             |
$orange                           |$green     $(sudo gsed -nE '/^ordertype =/p' $jmcfg) \033[58G$orange|
$orange                           |$green     $(sudo gsed -nE "/cjfee_$ordertype.=/p" $jmcfg) \033[58G$orange|
$orange                           |$green     $(sudo gsed -n '/cjfee_factor =/p' $jmcfg) \033[58G$orange|
$orange                           |$green     $(sudo gsed -n '/minsize =/p' $jmcfg) \033[58G$orange|
$orange                           |$green     $(sudo gsed -n '/size_factor =/p' $jmcfg) \033[58G$orange|
                           _______________________________ 

    $orange
    "

    #For onion address
    grep "setting onion hostname to" $jmcfg | tail -n1 | cut -d : -f 2

fi
########################################################################################
# Running status
########################################################################################
#if grep "setting onion hostname to" $logfile ; then
if ps ax | grep yg-privacyenhanced.py | grep -vq grep ; then
    wallet=$(ps ax | grep yg-privacyenhanced.py | grep -v grep | awk '{print $7}' | gsed -nE 's|\/.+\/||p')
    ygtext="    Yield Generator is:    $green   RUNNING$orange with wallet$magenta $wallet"
    
    if ps ax | grep obwatch | grep -q python ; then
        if [[ -z $nick ]] ; then
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

if ls $HOME/.joinmarket/wallets/ | grep -E "*.lock" ; then
cyanlock=$red ; orangelock=$red 
else
cyanlock=$cyan ; orangelock=$orange
fi
########################################################################################
#Lock file detection
########################################################################################
    cd $HOME/.joinmarket/wallets >$dn 2>&1
    list="" 
    for i in $(ls -a) ; do 
        if grep -q "lock" <<< $i ; then
            export list="${list}, $i" 
        fi
    done 
    cd - >$dn 2>&1
    lockfilelist=${list:2}
    debug "lock list... $lockfilelist"
########################################################################################
#Menu print
########################################################################################

set_terminal 48 88 ; echo -ne "
########################################################################################

                                   YIELD GENERATOR                         $cyan
                             Be a coinjoin market maker                   $orange

########################################################################################
$locktext

$ygtext
$orderbooknn

$green
                start)$orange    Start Yield Generator 
$red
                stop)$orange     Start Yield Generator 
$yellow
                c)$orange        Configure Yield Generator Settings...
$cyan
                log)$orange      Follow Yield Generator log as it populates
$cyan
                lesslog)$orange  Read Yield Generator log with less (logv for vim)
$cyanlock
                del)$orangelock      Lockfile info and fix ... $orange

$ygs

${red}Lock file(s): $lockfilelist$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;;

l)
clear
cd $HOME/.joinmarket/wallets
ls -lah
enter_continue
cd -
;;

start)
start_yield_generator
;;

stop)
stop_yield_generator
;;

lesslog)
   check_wallet_loaded || continue
   announce "Hint: Use q to exit the view screen"
   sudo less -R $logfile
;;
logv)
   check_wallet_loaded || continue
   vim_warning ; sudo vim $logfile
;; 
log)
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
enter_continue ; jump $enter_cont
fi
set_terminal 38 200
if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
tmux new -s yg_log "tail -f $logfile"
TMUX=$TMUX2
return 
}

function start_yield_generator {

    if [[ -n $ygrunning ]] ; then announce "Already running" ; continue ; fi
    check_wallet_loaded || return

    check_no_lock || return 1

    silentecho=true
    set_terminal
    announce "Please enter the password (not passphrase) for $wallet 
    (Keystrokes will not show)." 
    unset silentecho

    export password=$enter_cont
    TMUX2=$TMUX ; unset TMUX ; clear
    tmux new -s yg -d "source $HOME/parmanode/joinmarket/jmvenv/bin/activate ; 
    echo $password | $HOME/parmanode/joinmarket/scripts/yg-privacyenhanced.py $HOME/.joinmarket/wallets/$wallet --wallet-password-stdin |& tee $HOME/.joinmarket/yg_privacy.log ;
    deactivate ; "
    TMUX=$TMUX2
    unset password unet_cont
    jm_log_file_manager
}

function stop_yield_generator {
    yg_PID=$(ps ax | grep privacyenhanced.py | grep -v grep | awk '{print $1}')
    kill -15 $yg_PID
    jm_log_file_manager stop
    sudo rm $logfile 2>&1
}

function check_no_lock {

if [[ -z $wallet || $wallet = "NONE" ]] ; then return 0 ; fi

if ls $HOME/.joinmarket/wallets/ | grep -q "\.$wallet\.lock" ; then

    if ! [[ $1 == "silent" ]] ; then
        announce "There seems to be lock file on this wallet. The wallet may be in use, or
    a process using it may have failed to shut down gracefully. If it's the latter, it's
    safe to delete the lock file - it's just an empty file that acts as a signal. You can 
    delete it from the Yield Generator menu."
    fi

    export lockfile="true"
    return 1
else
    return 0
fi


}