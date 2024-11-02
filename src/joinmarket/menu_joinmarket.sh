function menu_joinmarket {
clear
export jmcfg="$HOME/.joinmarket/joinmarket.cfg" 

while true ; do 

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

    joinmarket_running="${green}RUNNING$orange"

    #is yield generator basic running?
    if docker exec joinmarket ps aux | grep yield-generator-basic ; then 
        yg="true"
    else
        yg="false"
    fi
    #is obwatcher running?
    obwatcherPID=$(docker exec joinmarket ps ax | grep "ob-watcher.py" | awk '{print $1}')
    if [[ $obwatcherPID =~ [0-9]+ ]] ; then
    orderbook="${green}RUNNING     $bright_blue Access: $IP:61000 or localhost:61000$orange"
    else
    orderbook="${red}NOT RUNNING"
    fi


else
     joinmarket_running="${red}NOT RUNNING$orange"
     yg="false"
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

$cyan
                  start)$orange       Start JoinMarket Docker container
$cyan
                  stop)$orange        Stop JoinMarket Docker container
$cyan
                  ob)$orange          Start/Stop orderbook
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
delete_line "${hm}" "jm_be_carefull=1"
fi
;;

shhh)
if ! grep "jm_menu_shhh=1" $hm >$dn 2>&1 ; then
echo "jm_menu_shhh=1" >> $hm
else
delete_line "${hm}" "jm_menu_shhh=1"
fi
;;

m2)
menu_joinmarket2
;;

vc)
sed '/^#/d' $jmcfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee /tmp/cfg >$dn 2>&1
sudo mv /tmp/cfg $jmcfg
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
load)
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
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" | tee /tmp/jmaddresses
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
hist)
    wallet_history_jm
    ;;
sp)
    spending_info_jm
    ;;
yg)
    check_wallet_loaded || continue
    menu_yield_generator || return 1
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
sed '/^#/d' $cfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee /tmp/cfg >$dn 2>&1
sudo mv /tmp/cfg $cfg
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

function menu_yield_generator {

while true ; do
set_terminal ; echo -e "
########################################################################################

                                   YEILD GENERATOR                         $cyan
                             Be a coinjoin market maker                   $orange

########################################################################################

$green
                    start)$orange    Start Yield Generator 
$red
                    stop)$orange     Start Yield Generator 
$yellow
                    c)$orange        Configure Yeild Generator Settings...
$cyan
                    log)$orange      Yield Generator log




########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;;

log)
    check_wallet_loaded || continue
    yield_generator_log || return 1
    ;;
c)
    configure_yg 
    ;;
*)
    invalid
    ;;
esac
done
}


function configure_yg {

if [[ $OS == Linux ]] && ! which bc >$dn 2>&1 ; then
    yesorno "Parmanode needs to install a tiny calculator, bc. OK?" && {
    echo "${green}Installing the bc caluclator, necessary for Parmanode to think...$orange"
    sudo apt-get update -y && sudo apt-get install bc
    } || return 1 
fi
########################################################################################

while true ; do #big loop for whole function

while true ; do
announce "Please type in the minimum size, in Satoshis, for the coinjoin you're oferring.
          \r    The default is 1 million sats."
case $enter_cont in
"")
swapstring $jmcfg "minsize =" "minsize = 1000000"
break
;;
*)
[[ $enter_cont -gt 0 ]] || { invalid && continue ; }
swapstring $jmcfg "minsize =" "minsize = 1000000"
break
;;
esac
done

########################################################################################
size_factor = 0.1

while true ; do
announce "For privacy, there is a default variance to your preferred size, set
         \r    at size_factor = 0.1, such that a size of 1M will randomly
         \r    be set tto 0.9M to 1.1M - this is to improve privacy.

         \r    You can leave the default of 0.1, just hit <enter>, or type in a value 
         \r    between 0 and 1."

case $enter_cont in
"")
swapstring $jmcfg "size_factor =" "size_factor = 0.1"
break
;;
*)
[[ $(echo "$enter_cont >= 0" | bc -l) == 1 && $(echo "$enter_cont <= 1" | bc -l) == 1 ]] || { invalid && continue ; }
swapstring $jmcfg "size_factor =" "size_factor = $enter_cont"
break
;;
esac
done

########################################################################################

while true ; do

    yesorno "Would you like to use a relative (percentage) fee offer, or an absolute value?" \
    "r" "relative" "abs" "absolute" \
        && { swapstring $jmcfg "ordertype =" "ordertype = reloffer" ; ordertype=r ; } \
        || { swapstring $jmcfg "ordertype =" "ordertype = absoffer" ; ordertype=a ; }

    if [[ $ordertype == r ]] ; then
        announce "Please type in a value for the relative fee, between 0 and 1.0, eg 0.00002
        \r    would be 0.002% (and 0.5 would ridiculously be 50%)"

        if ! [[ $(echo "$enter_cont > 0" | bc -l) == 1 && $(echo "$enter_cont < 1" | bc -l) ]] ; then
            invalid
            continue
        else
            swapstring $jmcfg "cjfee_r =" "cjfee_r = $enter_cont"
            break
        fi

    elif [[ $ordertype == a ]] ; then
        announce "Plese type in an absolute value in sats you want to receive for oferring coinjoins"
        [[ $enter_cont -ge 0 ]] || invalid && continue
        swapstring $jmcfg "cjfee_a =" "cjfee_a = $enter_cont"
        break
    fi

done

########################################################################################

while true ; do
announce "For privacy, there is a default variance to your preferred fee, set
         \r    at cjfee_factor = 0.1, such that a fee of 1000 will randomly
         \r    be set tto 900 to 1100 - this is to improve privacy.

         \r    You can leave the default of 0.1, just hit <enter>, or type in a value 
         \r    between 0 and 1."

case $enter_cont in
"")
swapstring $jmcfg "cjfee_factor =" "cjfee_factor = 0.1"
break
;;
*)
[[ $(echo "$enter_cont >= 0" | bc -l) == 1 && $(echo "$enter_cont <= 1" | bc -l) == 1 ]] || { invalid && continue ; }
swapstring $jmcfg "cjfee_factor =" "cjfee_factor = $enter_cont"
break
;;
esac
done

yesorno "  \r    The Following are your choices...
$cyan
           \r        $(gsed -n '/ordertype =/p' $jmcfg)
           \r        $(gsed -nE "/cjfee_$ordertype.=/p" $jmcfg)
           \r        $(gsed -n '/cjfee_factor =/p' $jmcfg)
           \r        $(gsed -n '/minsize =/p' $jmcfg)
           \r        $(gsed -n '/size_factor =/p' $jmcfg)" \
    "y" "yes, agree" "n" "no, start over" && return 0 || continue


done #end big loop

}


