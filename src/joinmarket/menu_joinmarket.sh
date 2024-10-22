function menu_joinmarket {

while true ; do 

if [[ -z $wallet ]] ; then wallet=NONE ; fi

if docker ps | grep -q joinmarket ; then
joinmarket_running="${green}RUNNING$orange"
else
joinmarket_running="${red}NOT RUNNING$orange"
fi

set_terminal_custom 47 ; echo -en "
########################################################################################$cyan

                                J O I N M A R K E T $orange

${red}${blinkon}JoinMarket is a HOT wallet - be careful.$blinkoff$orange
########################################################################################

    JoinMarket is:       $joinmarket_running

    Active wallet is:    $red$wallet$orange

$cyan
                  start)$orange       Start JoinMarket Docker container
$cyan
                  stop)$orange        Stop JoinMarket Docker container
$cyan
                  aw)$orange          Activate wallet (load to memory) 
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
                  yg)$orange          Yeild Generator ...

$orange   
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

start)
docker start joinmarket
;;
stop)
docker stop joinmarket
;;
aw)
set_terminal
choose_wallet
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
    display_jm_addresses
    ;; 
dall)
    display_jm_addresses a
    ;;
sum)

    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet summary" | tee /tmp/jmaddresses
    enter_continue
    ;;
cp)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet changepass" 
    ;;

su)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showutxos" 
    enter_continue
    ;;
ss)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet showseed" 
    enter_continue
    ;;
yg)
    yeild_generator
    ;;

*)
invalid
;;

esac
done
}

function delete_jm_wallets {

set_terminal ; echo -e "
########################################################################################

    The following is a list of the contents of$cyan $HOME/.joinmarket/wallets/:
$pink
$(ls $HOME/.joinmarket/wallets/)
$orange

    Are you sure you want to delete everything in there?
$red
                 yolodelete)   delete it all
$green
                 *)            Any other key will abort
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
yolodelete)
sudo rm -rf $HOME/.joinmarket/wallets/*
enter_continue "DONE"
;;
*)
return 1
;;
esac
}


function display_jm_addresses {

    if [[ ! -e $HOME/.joinmarket/wallets/wallet.jmdat ]] ; then
    announce "${cyan}wallet.jmdat$orange does not exist"
    return
    fi

set_terminal ; echo -e "
########################################################################################

    The wallet addresses will be printed for you inside the 'less' command. Use the
    keyboard arrows to go up and down (you can actually use vim commands if you know
    them). Then hit 'q' to exit it.

########################################################################################
"
enter_continue

    case $1 in
    a)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet displayall" | tee /tmp/jmaddresses
    ;;
    *)
    docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py $wallet display" | tee /tmp/jmaddresses
    ;;
    esac

    if grep -q "just restart this joinmarket application" < /tmp/jmaddresses ; then

        enter_continue "$pink
        This always happens the first time you access the display function.
        Please hit enter to run the display command again.
        $orange"
        case $1 in
        a)
        docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py wallet.jmdat displayall" | tee /tmp/jmaddresses
        ;;
        *)
        docker exec -it joinmarket bash -c "/jm/clientserver/scripts/wallet-tool.py wallet.jmdat display" | tee /tmp/jmaddresses
        ;;
        esac

    fi

clear
sed -i '1,/[Mm]ixdepth/{/[Mm]ixdepth/!d}' /tmp/jmaddresses
sed -i -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' /tmp/jmaddresses #removeds escape characters
sed -i '/^[Mm]ixdepth/i\\' /tmp/jmaddresses
sed -i "1i##################################### wallet.jmdat #####################################" /tmp/jmaddresses
echo "
####################################### END #########################################" | tee -a /tmp/jmaddresses >$dn
clear
less /tmp/jmaddresses
#rm /tmp/jmaddresses >$dn 2>&1
enter_continue

}

function yeild_generator {
set_terminal ; echo -e "
########################################################################################

    Some important information to ensure you don't have a bad time.

    - If yeild generator is running, do not try to initiate a 'take' transaction, as
      you'll get an error that the wallet is locked.

    - You can tweak the settings (eg fees) by editing the configuration file (access
      via JoinMarket Parmanode menu
    
    - The generator is a python script which will run inside the docker conainter.


########################################################################################
"
enter_continue

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please make a choice...

            1) Yeild Generator Basic (recommended to begin with)

            2) Yeild Generator Privacy Enhanced

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
docker exec -d joinmarket python3 /jm/clientserver/script/yield-generator-basic.py |& tee -a $HOME/.joinmarket/yg_basic.log
;;
2)
docker exec -d joinmarket python3 /jm/clientserver/script/yg-privacyenhanced.py |& tee -a $HOME/.joinmarket/yg_privacy.log
;;
*)
invalid
;;
esac
done


}

function choose_wallet {
cd $HOME/.joinmarket/wallets >$dn 2>&1 || return
set_terminal ; echo -e "
########################################################################################

    Please choose a wallet, type the file name exaclty, then <enter>
"
for i in $(ls) ; do echo -e "    $bright_blue$i$orange" ; done
cd - >$dn 2>&1
echo -en "
$orange
########################################################################################
"
read wallet
export wallet
enter_continue
}
