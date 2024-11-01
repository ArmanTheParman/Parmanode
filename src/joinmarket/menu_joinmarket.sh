function menu_joinmarket {

while true ; do 

if ! grep "jm_be_careful=1" $hm >$dm 2>&1 ; then
    export be_carefull="${red}${blinkon}JoinMarket is a HOT wallet - be careful.
    ${blinkoff}${red}Type$cyan relax$orange to toggle this warning.$orange"
else
    unset be_carefull
fi


if [[ -z $wallet ]] ; then wallet=NONE ; fi

if docker ps | grep -q joinmarket ; then

    joinmarket_running="${green}RUNNING$orange"

    #is yield generator basic running?
    if docker exec joinmarket ps aux | grep yield-generator-basic ; then 
        yg="true"
    else
        yg="false"
    fi

else
     joinmarket_running="${red}NOT RUNNING$orange"
     yg="false"
fi

set_terminal_custom 50 ; echo -en "
########################################################################################$cyan

                                J O I N M A R K E T $orange
$be_carefull
########################################################################################

    JoinMarket is:       $joinmarket_running

    Active wallet is:    $red$wallet$orange

$cyan
                  start)$orange       Start JoinMarket Docker container
$cyan
                  stop)$orange        Stop JoinMarket Docker container
$cyan
                  load)$orange        Load wallet 
$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$cyan
                  vc)$orange          Remove all config comments and make pretty
$cyan
                  man)$orange         Manually access container and mess around
$cyan
                  cr)$orange          Create JoinMarket Wallet (with info)
$cyan
                  delete)$orange      Delete JoinMarket Wallet 
$cyan
                  display)$orange     Display addresses & balances
$cyan
                  dall)$orange        Display but including internal addresses
$cyan
                  sum)$orange         Summary of balances
$cyan
                  cp)$orange          Change wallet encryption password 
$cyan
                  su)$orange          Show wallet UTXOs
$cyan
                  ss)$orange          Show wallet seed words
$red
                  yg)$orange          Yield Generator ...
$red
                  log)$orange         Yield Generator log

$orange   
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

relax)
if ! grep "jm_be_careful=1" $hm >$dn 2>&1 ; then
echo "jm_be_careful=1" >> $hm
else
delete_line $hm "jm_be_careful=1"
fi
;;

start)
docker start joinmarket
;;
stop)
docker stop joinmarket
;;
load)
set_terminal
choose_wallet || continue
;;
conf)
sudo nano $HOME/.joinmarket/joinmarket.cfg
;;
confv)
sudo vim $HOME/.joinmarket/joinmarket.cfg
;;
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
cr)
    > $dp/before ; > $dp/after
    for i in $(ls $HOME/.joinmarket/wallets/) ; do echo "$i" >> $dp/before 2>/dev/null ; done
    jm_create_wallet_tool
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py generate" 
        for i in $(ls $HOME/.joinmarket/wallets/) ; do echo "$i" >> $dp/after 2>/dev/null ; done
    export wallet=$(diff $dp/before $dp/after | grep ">" | awk '{print $2}')
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" 
    > $dp/before ; > $dp/after
    ;;
delete)
    delete_jm_wallets
    ;; 

display)
    check_wallet_loaded || continue
    display_jm_addresses
    ;; 
dall)
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
yg)
    check_wallet_loaded || continue
    yield_generator || return 1
    ;;
log)
    check_wallet_loaded || continue
    yield_generator_log || return 1
    ;;
*)
invalid
;;

esac
done
}