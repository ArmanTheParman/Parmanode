function menu_joinmarket2 {
if ! grep -q "joinmarket-end" $ic ; then return 0 ; fi
clear
export jmcfg="$HOME/.joinmarket/joinmarket.cfg" 
export logfile="$HOME/.joinmarket/yg_privacy.log"
export oblogfile="$HOME/.joinmarket/orderbook.log"
while true ; do 


########################################################################################
#wallet detection...
########################################################################################
if [[ -z $wallet ]] ; then 
    #start by setting wallet to NONE
    wallet=NONE

    #check if yg running, and load wallet variable, and set menu text
    if ps ax | grep yg-privacyenhanced.py | grep -q python ; then
    wallet=$(ps ax | grep yg-privacyenhanced.py | grep python | grep -Eo 'wallets/.*$' | cut -d / -f2 | grep -Eo '^.+ ')
    ygtext1="
    Yield Generator :   $green RUNNING$orange with wallet$magenta $wallet
"
    else
        ygext=""
    fi

    #if yg wasn't running then wallet is NONE, then load a wallet if there is only one of them, otherwise leave as NONE
    if [[ $wallet == "NONE" ]] && [[ $(ls $HOME/.joinmarket/wallets/ | wc -w | tr -d ' ') == 1 ]] ; then
        wallet=$(ls $HOME/.joinmarket/wallets/)
    fi

# if there is a wallet loaded, then check if yg is running for the menu
else
	if ps ax | grep yg-privacyenhanced.py | grep -vq grep ; then
    ygtext1="
    Yield Generator is: $green RUNNING$orange with wallet$magenta $wallet
"
	fi
fi

#is yield generator basic running?
if ps aux | grep yield-generator-basic ; then 
    export yg="true"
else
    export yg="false"
fi
########################################################################################
#Obwatcher detection
########################################################################################
export obwatcherPID=$(ps ax | grep "ob-watcher.py" | grep -v grep | awk '{print $1}')

if [[ $obwatcherPID =~ [0-9]+ ]] ; then
    export orderbook="${green}RUNNING$orange \n\n    Access Order Book\n      -from internal:$bright_blue    http://localhost:62601$orange or$bright_blue http://127.0.0.1:62601$orange
      -from external:$bright_blue    http://$IP:61000$orange"
else
    export orderbook="${red}NOT RUNNING$orange"
    unset obwatcherPID
fi
########################################################################################
#config mod detection
########################################################################################
if ! [[ -e ${jmcfg}_backup ]] ; then
    configedit="$cyan
                  vc)$orange          Remove all config comments and make pretty"
else
    unset configedit 
fi

########################################################################################
#Menu print
########################################################################################
set_terminal_custom 51 ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N $orange
$jm_be_carefull
########################################################################################

    Active wallet is:    $magenta$wallet$orange

    Order Book is:       $orderbook
$ygtext1

$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$configedit 
$cyan
                  man)$orange         Enter virtual Python environment and play
                                      with scripts manually (for experts)
$cyan
                  mm)$orange          Back to first ParmaJoin menu...

$orange   
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
mm)
menu_joinmarket
;;

conf)
    sudo nano $jmcfg 
;;

confv)
vim_warning ; sudo vim $jmcfg
;;

# vc)
# if [[ -e "${jmcfg}_backup" ]] ; then enter_continue "exists" ; continue ; fi
# enter_continue "doesn't exist"
# yesorno "The file will be modified to delete the comments and make this large file more 
#     managable. A backup will be kept as ${jmcfg}_backup
#     so you can still investigate what the comments say in the future.
    
#     Proceed?" || continue

# sed '/^#/d' $jmcfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee ${jmcfg}_backup >$dn 2>&1
# sudo cp ${jmcfg}_backup $jmcfg 
# enter_continue "File modified."
# ;;
vc)
if [[ -e "${jmcfg}_backup" ]] ; then enter_continue "exists" ; continue ; fi
yesorno "The file will be modified to delete the comments and make this large file more 
    managable. A backup will be kept as ${jmcfg}_backup
    so you can still investigate what the comments say in the future.
    
    Proceed?" || continue

cp $jmcfg ${jmcfg}_backup

cat $jmcfg | while IFS= read -r line ; do {

echo "$line" | tr -d "\r" | xargs >$dn 2>&1    

    if grep -Eq "^#" <<< $line ; then continue ; fi
    
    if grep -Eq "\[.*\]" <<< $line ; then
        echo -e "\n$line\n" | tee -a ${jmcfg}_temp >$dn 2>&1
        continue
    fi

    if grep -Eq "^[^ ].*$" <<< $line ; then #ignore empty lines doesn't work, so had to do lines starting with space
       echo -e "$line" | tee -a ${jmcfg}_temp >$dn 2>&1
    fi

    }
    done
sudo cp ${jmcfg}_temp $jmcfg 
enter_continue "File modified."

;;

man)
announce "You're entering a TMUX sessions (terminal container). Exit by either
    typing 'exit' or, <control> b then d to detach from the session and leave 
    any scripts running - the latter is not recommended unless you know a thing 
    or two about TMUX. Not hard to learn using the internet."
jump $enter_cont
TMUX2=$TMUX ; unset TMUX

if ! tmux ls | grep -q man_jm ; then
    tmux new -s man_jm -d
    tmux send-keys -t man_jm "source $HOME/parmanode/joinmarket/jmvenv/bin/activate" C-m
    tmux send-keys -t man_jm "cd $HOME/parmanode/joinmarket/scripts ; clear" C-m
    tmux a -t man_jm
fi

tmux a -t man_jm

TMUX=$TMUX2
;;

*)
invalid
;;
esac
done
}



