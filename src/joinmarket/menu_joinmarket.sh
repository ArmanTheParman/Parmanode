function menu_joinmarket {

while true ; do 
if docker ps | grep -q joinmarket ; then
joinmarket_running="${green}RUNNING$orange"
else
joinmarket_running="${red}NOT RUNNING$orange"
fi

set_terminal_custom 47 ; echo -en "
########################################################################################$cyan
                                J O I N M A R K E T $orange
########################################################################################


    JoinMarket is:    $joinmarket_running

$cyan
                  start)$orange       Start JoinMarket Docker container
$cyan
                  stop)$orange        Stop JoinMarket Docker container
$cyan
                  conf)$orange        Edit the configuration file (confv for vim)
$cyan
                  vc)$orange          View config only - and without comments 
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
conf)
sudo nano $HOME/.joinmarket/joinmarket.cfg
;;
confv)
sudo vim $HOME/.joinmarket/joinmarket.cfg
;;
vc)
cfg="$HOME/.joinmarket/joinmarket.cfg" 
sed '/^#/d; /^$/d; /\[/a\ ; /\[/i\ ' $cfg | less
enter_continue
;;
man)
clear
enter_continue "Type exit and <enter> to return from container back to Parmanode"
clear
docker exec -it joinmarket bash 
;;
cr)
    jm_create_wallet_tool
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py generate' 
    enter_continue
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat summary' 
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

    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat summary' | tee /tmp/jmaddresses
    enter_continue
    ;;
cp)
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat changepass' 
    ;;

su)
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat showutxos' 
    enter_continue
    ;;
ss)
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat showseed' 
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
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat displayall' | tee /tmp/jmaddresses
    ;;
    *)
    docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat display' | tee /tmp/jmaddresses
    ;;
    esac

    if grep -q "just restart this joinmarket application" < /tmp/jmaddresses ; then

        enter_continue "$pink
        This always happens the first time you access the display function.
        Please hit enter to run the display command again.
        $orange"
        case $1 in
        a)
        docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat displayall' | tee /tmp/jmaddresses
        ;;
        *)
        docker exec -it joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py wallet.jmdat display' | tee /tmp/jmaddresses
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

set_terminal -e "
########################################################################################

    Some important information to ensure you don't have a bad time.

    - If yeild generator is running, do not try to initiate a 'take' transaction, as
      you'll get an error that the wallet is locked.

    - You can tweak the settings (eg fees) by editing the configuration file.


########################################################################################
"
enter_continue


}
