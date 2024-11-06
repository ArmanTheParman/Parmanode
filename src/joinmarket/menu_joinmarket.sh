function menu_joinmarket {
clear
export jmcfg="$HOME/.joinmarket/joinmarket.cfg" 
export logfile="$HOME/.joinmarket/yg_privacy.log"
export oblogfile="$HOME/.joinmarket/orderbook.log"
while true ; do 

socatstatus=$(if tmux ls | grep -q joinmarket_socat ; then 
echo "${green}RUNNING$orange"
else echo "${red}NOT RUNNING$orange"
fi)

if ! grep "jm_be_carefull=1" $hm >$dn 2>&1 ; then
export jm_be_carefull="
${red}${blinkon}ParmaJoin uses a HOT wallet - be careful.
${blinkoff}${red}Type$cyan relax$red to toggle this warning.$orange"
else
    unset jm_be_carefull
fi

if ! grep "jm_menu_shhh=1" $hm >$dn 2>&1 ; then
export jm_menu_shhh="${bright_blue}If you remember them, you can execute menu 2 commands here as well.
Type$cyan shhh$bright_blue to toggle this on and off.
"
else
    unset jm_menu_shhh
fi

if [[ -z $wallet ]] ; then wallet=NONE ; fi

if docker ps 2>$dn | grep -q joinmarket ; then

    export joinmarket_running="${green}RUNNING$orange"

    #is yield generator basic running?
    if docker exec joinmarket ps aux | grep yield-generator-basic ; then 
        export yg="true"
    else
        export yg="false"
    fi

    #is obwatcher running?
    export obwatcherPID=$(docker exec joinmarket ps ax | grep "ob-watcher.py" | awk '{print $1}')
    if [[ $obwatcherPID =~ [0-9]+ ]] ; then
        export orderbook="${green}RUNNING     $bright_blue Access: $IP:61000 or localhost:61000$orange"
    else
        export orderbook="${red}NOT RUNNING$orange"
    fi

else
     export joinmarket_running="${red}NOT RUNNING$orange"
     export yg="false"
     export orderbook="${red}NOT RUNNING${orange}"
fi
set_terminal_custom 51 ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N $orange
$jm_be_carefull
########################################################################################

    JoinMarket is:       $joinmarket_running
    Active wallet is:    $red$wallet$orange
    Order Book is:       $orderbook
    Socat is:            $socatstatus

$cyan
                  s)$orange           Start/stop JoinMarket Docker container
$cyan
                  ob)$orange          Start/Stop orderbook
$cyan
                  socat)$orange       Start/Stop Socat forwarding ...
$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$magenta
                  ww)$orange          Wallet menu ... 
$red
                  yg)$orange          Yield Generator menu ...
$bright_blue
                  mm)$orange          Menu 2 ...

$jm_menu_shhh$orange   
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

relax)
if ! grep "jm_be_carefull=1" $hm >$dn 2>&1 ; then
echo "jm_be_carefull=1" >> $hm
else
sudo gsed -i "/jm_be_carefull=1/d" $hm
fi
;;
shhh)
if ! grep "jm_menu_shhh=1" $hm >$dn 2>&1 ; then
echo "jm_menu_shhh=1" >> $hm
else
sudo gsed -i "/jm_menu_shhh=1/d" $hm
fi
;;

s)
if echo $joinmarket_running | grep -q NOT ; then
start_joinmarket
else
stop_joinmarket
unset obwatcherPID
fi
;;

ob)
    orderbook_jm
;;

socat)
    check_socat_working || return 1
;;

l|load)
    set_terminal
    choose_wallet || continue
;;

conf)
    sudo nano $jmcfg 
;;

ww)
    menu_joinmarketwallet
;;

yg)
    menu_yield_generator || return 1
    ;;

mm)
    menu_joinmarket2
;;

vc)
sed '/^#/d' $jmcfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $jmcfg
enter_continue "file modified"
;;
confv)
sudo vim $jmcfg
;;

man)
clear
enter_continue "Type exit and <enter> to return from container back to Parmanode"
clear
docker exec -it joinmarket bash 
;;
cr)

    jm_create_wallet_tool

    ;;
delete)
    delete_jm_wallets
    ;; 

da)
    check_wallet_loaded || continue
    display_jm_addresses
    ;; 
di)
    check_wallet_loaded || continue
    display_jm_addresses a
    ;;
sum)

    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" | tee $tmp/jmaddresses
    enter_continue
    ;;
cp)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet changepass" 
    ;;

su)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showutxos" 
    enter_continue
    ;;
ss)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showseed" 
    enter_continue
    ;;
bk)
    backup_jm_wallet
    ;;
h|hist)
    wallet_history_jm
    ;;
sp)
    spending_info_jm
    ;;
*)
invalid
;;
esac
done
}