function menu_joinmarket {
clear
export jmcfg="$HOME/.joinmarket/joinmarket.cfg" 
export logfile="$HOME/.joinmarket/yg_privacy.log"
export oblogfile="$HOME/.joinmarket/orderbook.log"
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

if [[ -z $wallet ]] ; then 
    #start by setting wallet to NONE
    wallet=NONE

    #check if yg running, and load wallet variable, and set menu text
    if docker exec joinmarket ps ax | grep yg-privacyenhanced.py | grep -vq bash ; then
    wallet=$(docker exec joinmarket ps ax | grep yg-privacyenhanced.py | grep -v bash | awk '{print $7}' | gsed -nE 's|\/.+\/||p')
    #ygtext1 ... doin't rename, needs to not be ygtext (clashes with yg menu version)
    ygtext1="
    Yield Generator is: $green RUNNING$orange with wallet$magenta $wallet
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
	if docker exec joinmarket ps ax | grep yg-privacyenhanced.py | grep -vq bash ; then
    ygtext1="
    Yield Generator is: $green RUNNING$orange with wallet$magenta $wallet
"
	fi
fi

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
        export orderbook="${green}RUNNING$orange \n    Access Order Book\n    from internal:   $bright_blue    localhost:61000 or 127.0.0.1:61000$orange"
    else
        export orderbook="${red}NOT RUNNING$orange"
    fi

else
     export joinmarket_running="${red}NOT RUNNING$orange"
     export yg="false"
     export orderbook="${red}NOT RUNNING${orange}"
fi

if tmux ls | grep -q joinmarket_socat ; then 
    if echo $orderbook | grep -q NOT ; then
        socatstatus="${green}RUNNING$orange"
    else
        socatstatus="${green}RUNNING$orange
    Access Order Book
    from external: $bright_blue      $IP:61000$orange"
    fi
else 
    socatstatus="${red}NOT RUNNING$orange"
fi

set_terminal_custom 51 ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N $orange
$jm_be_carefull
########################################################################################


    JoinMarket is:       $joinmarket_running

    Active wallet is:    $magenta$wallet$orange

    Socat is:            $socatstatus

    Order Book is:       $orderbook
$ygtext1

$cyan
                  s)$orange           Start/stop JoinMarket Docker container
$cyan
                  ob)$orange          Start/Stop orderbook
$cyan
                  obi)$orange         Orderbook access info ...
$cyan
                  ss)$orange          Start/Stop Socat forwarding (ssi for info)
$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$magenta
                  ww)$orange          Wallet menu ... 
$red
                  yg)$orange          Yield Generator menu ...
$red
                  man)$orange         Manual DIY commands (enter Docker container)
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

    if [[ $yg == "true" ]] ; then
    stop_yeild_generator
    fi

    stop_joinmarket
    unset obwatcherPID
fi
;;

ob)
    orderbook_jm
;;

obi)
   orderbook_access_info
;;
ss)
   if grep -q "NOT" <<< $socatstatus ; then
   start_socat joinmarket
   else
   stop_socat joinmarket
   fi
;;
ssi)
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
vim_warning ; sudo vim $jmcfg
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

function orderbook_access_info {

set_terminal ; echo -e "
########################################################################################

    The order book is a bit like the Bitcoin mempool. JoinMarket users each keep their
    own copy of the coinjoin offers, and share them between other users. Not every
    copy is going to be identical.

    Sometimes there are connection issues over the Tor Network and your list might
    not look complete. Refreshing can help.

    Your orderbook can be accessed from the URLs provided in the main JoinMarket menu.

    An althernative to a self-hosted order book is to use a public one. Here's one
    example you could use:
$bright_blue
    https://nixbitcoin.org/orderbook/
$orange
    To see your offer listed in the order book, you first need to find your nickname,
    a randomly generated string generated by JoinMarket. It'll be in the 
    Yield Generator Menu.

########################################################################################
"
enter_continue

}
