function menu_joinmarket {
clear
export jmcfg="$HOME/.joinmarket/joinmarket.cfg" 
export logfile="$HOME/.joinmarket/yg_privacy.log"
while true ; do 

socatstatus=$(if tmux ls | grep -q joinmarket_socat ; then 
echo "${green}running$orange (type 'stop' to stop)" 
else echo "${red}not running$orange (type 'start' to start)"
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
debug "pause"
set_terminal_custom 51 ; echo -e "\033[H" ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N $orange
$jm_be_carefull
########################################################################################

    JoinMarket is:       $joinmarket_running
    Active wallet is:    $red$wallet$orange
    Order Book is:       $orderbook
    Socat is:

$cyan
                  start)$orange       Start JoinMarket Docker container
$cyan
                  stop)$orange        Stop JoinMarket Docker container
$cyan
                  ob)$orange          Start/Stop orderbook
$cyan
                  socat)$orange       Start/Stop Socat forwarding
$cyan
                  load)$orange        Load wallet 
$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$cyan
                  cr)$orange          Create/Recover JoinMarket Wallet (with info)
$cyan
                  da)$orange          Display addresses & balances
$cyan
                  di)$orange          Display but including internal addresses
$cyan
                  sum)$orange         Summary of balances
$cyan
                  su)$orange          Show wallet UTXOs
$red
                  yg)$orange          Yield Generator ...
$bright_blue
                  m2)$orange          Menu 2 ...

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

m2)
menu_joinmarket2
;;

vc)
sed '/^#/d' $jmcfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $jmcfg
enter_continue "file modified"
;;

start)
start_joinmarket
;;
stop)
stop_joinmarket
unset obwatcherPID
;;
ob)
orderbook_jm
;;
l|load)
set_terminal
choose_wallet || continue
;;
conf)
sudo nano $jmcfg 
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
yg)
    menu_yg || return 1
    ;;
socat)
    check_socat_working || return 1
    ;;
*)
invalid
;;

esac
done
}

function menu_joinmarket2 {
while true ; do
set_terminal ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N
                                      Menu 2$orange

########################################################################################

    Active wallet is:    $red$wallet$orange


$cyan
                  vc)$orange          Remove all config comments and make pretty
$cyan
                  man)$orange         Manually access container and mess around
$cyan
                  delete)$orange      Delete JoinMarket Wallet 
$cyan
                  cp)$orange          Change wallet encryption password 
$cyan
                  ss)$orange          Show wallet seed words
$cyan
                  bk)$orange          Backup wallet file
$cyan
                  hist)$orange        Show a history of the wallet's transactions
$cyan
                  sp)$orange          Spending from the wallet (info) 

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 0 ;; 

vc)
cfg="$HOME/.joinmarket/joinmarket.cfg" 
sed '/^#/d' $cfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $cfg
enter_continue "file modified"
;;
man)
clear
enter_continue "Type exit and <enter> to return from container back to Parmanode"
clear
docker exec -it joinmarket bash 
;;

delete)
    delete_jm_wallets
    ;; 
cp)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet changepass" 
    ;;
ss)
    check_wallet_loaded || continue
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showseed" 
    enter_continue
    ;;
bk)
    backup_jm_wallet
    ;;
hist)
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

function backup_jm_wallet {

while true ; do
set_terminal ; echo -e "
########################################################################################

    The following is a list of the contents of$cyan $HOME/.joinmarket/wallets/:
    
$red
$(ls $HOME/.joinmarket/wallets/)
$orange

    Please type in exactly the filename of the wallet you wish to backup. Parmanode
    will copy the file (not move, but copy) to your desktop. It'll be easy for you
    to see it there and then you can simply save it to where you want. 

$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)

[[ $choice =~ ^/ ]] && invalid && continue

if [[ -e $HOME/Desktop/$choice ]] ; then
announce "The file seems to exist on the Desktop already. Please move it or delete it
    first." && continue
fi

sudo cp $HOME/.joinmarket/wallets/$choice $HOME/Desktop/$choice
enter_continue
return 0
;;
esac
done
}

function wallet_history_jm {
check_wallet_loaded || return 1
docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet history" 
enter_continue
}

function spending_info_jm {

set_terminal ; echo -e "
########################################################################################

    Parmanode does not recommend or enable terminal based commands to spend from the
    JM wallets. It's best that you restore your seed into a hardware wallet device,
    and explore your wallets using Sparrow or Electrum. Then generate transactions
    from there.

    Remember that you'll need to modify the 'account' value in the derivation path
    to see all your mixing depths.

    If you really want to use the command prompt to spend coins out of this wallet,
    eg if you lost your seed an you only have a JM wallet file, then you can choose 
    the manual access from the menu. You'll then be in the Docker container at the 
    directory with all the scripts. You can look up the JoinMarket documentation 
    and execute whichever script you want.

    I may include functions to do this automatically one day, and can take requests
    if there is demand.

########################################################################################
"
enter_continue
return 0
}

function orderbook_jm {
if [[ -z $obwatcherPID ]] ; then
docker exec -d joinmarket /jm/clientserver/scripts/obwatch/ob-watcher.py >/dev/null 2>&1
else
docker exec joinmarket kill $obwatcherPID
fi
}

function check_socat_working {

while true ; do
socatstatus=$(if tmux ls | grep -q joinmarket_socat ; then 
echo "${green}running$orange (type 'stop' to stop)" 
else echo "${red}not running$orange (type 'start' to start)"
fi)
set_terminal ; echo -e "
########################################################################################

    Socat runs in a tmux session in the background and takes traffic comming in on 
    port 61000 and delivers it to the port 62610, which is the order book server's
    port listening for connecitons. Some sort of middle handpassing of traffic is 
    necessary like this to get to the order book server from a different computer.

    If you don't understand any of that, don't worry about it, just make sure it's
    running if you want external access.

    Socat/Tmux is currently: $socatstatus


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
start)
start_socat joinmarket
;;
stop)
stop_socat joinmarket
;;
*)
invalid
;;
esac
done



}