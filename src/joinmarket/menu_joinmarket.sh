function menu_joinmarket {
if ! grep -q "joinmarket-end" $ic ; then return 0 ; fi
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
    debug "in none"
    #start by setting wallet to NONE
    wallet=NONE

    #check if yg running, and load wallet variable, and set menu text
    if ps ax | grep yg-privacyenhanced.py | grep -q python ; then
    wallet=$(ps ax | grep yg-privacyenhanced.py | grep python | grep -Eo 'wallets/.*$' | cut -d / -f2 | grep -Eo '^.+ ')
    debug "wallet is $wallet"
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
    debug "in else"
	if ps ax | grep yg-privacyenhanced.py | grep -vq grep ; then
    ygtext1="
    Yield Generator is: $green RUNNING$orange with wallet$magenta $wallet
"
	fi
fi

debug "w = $wallet"

#is yield generator basic running?
if ps aux | grep yield-generator-basic ; then 
    export yg="true"
else
    export yg="false"
fi

#is obwatcher running?
export obwatcherPID=$(ps ax | grep "ob-watcher.py" | grep -v grep | awk '{print $1}')
if [[ $obwatcherPID =~ [0-9]+ ]] ; then
    export orderbook="${green}RUNNING$orange \n\n    Access Order Book\n      -from internal:$bright_blue    http://localhost:62601$orange or$bright_blue http://127.0.0.1:62601$orange
      -from external:$bright_blue    http://$IP:61000$orange"

else
    export orderbook="${red}NOT RUNNING$orange"
    unset obwatcherPID
fi

set_terminal_custom 51 ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N $orange
$jm_be_carefull
########################################################################################

    Active wallet is:    $magenta$wallet$orange

    Order Book is:       $orderbook
$ygtext1

$cyan
                  info)$orange        How to play with your bitcoins 
$magenta
                  ww)$orange          Wallet menu ... 
$cyan
                  gui)$orange         Start Joinmarket GUI (CJ taker)
$red
                  yg)$orange          Yield Generator menu (CJ Maker) ...
$cyan
                  ob)$orange          Start/Stop orderbook
$cyan
                  obi)$orange         Orderbook access info ...
$cyan
                  obl)$orange         Order book log (obln for nano)
$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$cyan
                  vc)$orange          Remove all config comments and make pretty
$cyan
                  sp)$orange          Spending (info) ...

$orange   
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 

relax)
if ! grep "jm_be_carefull=1" $hm >$dn 2>&1 ; then
echo "jm_be_carefull=1" >> $hm
else
sudo gsed -i "/jm_be_carefull=1/d" $hm
fi
;;

gui)
    jmvenv "activate"
    $hp/joinmarket/scripts/joinmarket-qt.sh
    jmvenv "deactivate"
;;

ob)
    orderbook_jm
;;

obi)
   orderbook_access_info
;;

l|load)
    set_terminal
    choose_wallet || continue
;;

conf)
    sudo nano $jmcfg 
;;

confv)
vim_warning ; sudo vim $jmcfg
;;

ww)
    menu_joinmarketwallet
;;

yg)
    menu_yield_generator || return 1
    ;;

vc)
sed '/^#/d' $jmcfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $jmcfg
enter_continue "file modified"
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
    jmvenv "activate"
    $HOME/joinmarket/scripts/wallet-tool.py $wallet summary | tee $tmp/jmaddresses
    jmvenv "deactivate"
    enter_continue
    ;;
cp)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet changepass
    jmvenv "deactivate"
    ;;

su)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet showutxos
    jmvenv "deactivate"
    enter_continue
    ;;
ss)
    check_wallet_loaded || continue
    jmvenv "activate"
    $hp/joinmarket/scripts/wallet-tool.py $wallet showseed
    jmvenv "deactivate"
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

vc)
cfg="$HOME/.joinmarket/joinmarket.cfg" 
sed '/^#/d' $cfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $cfg
enter_continue "file modified"
;;

sp)
spending_info_jm
;;

obl)
announce "Hit q to exit this. Use 'vim' style controls to move about.

          \r    Note that connection advice in this output (localhost:62601)
          \r    will not work because it's running in a Docker container.
          \r    Just follow the connection information in the 
          \r    Parmanode menu.
"
less -R $oblogfile
;;
obln)
announce "Hit control x to exit nano text editor.

          \r    Note that connection advice in this output (localhost:62601)
          \r    will not work because it's running in a Docker container.
          \r    Just follow the connection information in the 
          \r    Parmanode menu.
"
nano $oblogfile
;;
info)
parmajoin_info
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
enter_continue ; jump $enter_cont

}

function parmajoin_info {

set_terminal_high ; echo -e "
########################################################################################
  $cyan                                PARMAJOIN INFO $orange
########################################################################################

    ParmaJoin is software that uses JoinMarket, and gives you an interative menu.

    You'll first have to create a wallet and fund it.

    Then you can decide how you want to coinjoin. There are two ways. Either as
    a maker or a taker.
$cyan
    TAKER:
$orange        
        To be a taker, ie pay a fee to coinjoin, you have to use the GUI. Load it up
        and then use it to load your wallet. Set the configuration opions, and
        then do a single CJ or go through the 'tumbler' continuous mixer.
$cyan
    MAKER:
$orange
        As a maker, you need to use the yeild generator. There isn't a GUI for this.
        You go to the Parmanode Yeild Generator submenu (after loading a wallet),
        set your CJ terms and then start the Yeild Generator background process. 
        This is basically a script which puts your offer on the market. You can see
        the state of the market by running your own OrderBook (see ParmaJoin main
        menu). There'll be a URL and you can go their to see your order is live. 
        You can identify your order with the 'nickname' printed in the YG menu.
$cyan
    Note:
$orange        
        If the YG stops abruptly (ie doesn't go througha graceful shutdown), then
        there will be a residual lock file (which is there to prevent double usage
        of the same wallet). You need to approve this to be deleted before you can
        start the YG again. There's a menu option for that.

$red
        Have fun playing with your bitcoins, and whatever else that you do.$orange

########################################################################################
"
enter_continue
}