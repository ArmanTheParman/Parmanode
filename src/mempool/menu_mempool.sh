function menu_mempool {
while true ; do 
set_terminal
if docker ps 2>/dev/null | grep -q mempool_web && \
   docker ps 2>/dev/null | grep -q mempool/backend && \
   docker ps 2>/dev/null | grep maria | grep -q docker-db ; then
running="                           MEMPOOL IS$green    Running$orange"
else
running="                           MEMPOOL IS$red    Not Running$orange"
fi

unset ONION_ADDR_MEM tor_mempool tor_mempool_status output_tor

if sudo test -e $macprefix/var/lib/tor/mempool-service && sudo grep -q "mempool-service" $macprefix/etc/tor/torrc ; then
debug "var lib tor mempool-service if exists"
get_onion_address_variable mempool
tor_mempool_status="${green}enabled$orange"
tor_mempool="true"
get_onion_address_variable "mempool" || enter_continue "couldn't get mempool tor address"
output_tor=" Tor Access: $bright_blue    

    http://$ONION_ADDR_MEM:8280 $orange   
    " 
else
tor_mempool="false"
tor_mempool_status="${red}disabled$orange"
unset output_tor
fi

#get backend variable
if grep "MEMPOOL_BACKEND" < $hp/mempool/docker/docker-compose.yml | grep -q "none" ; then

    export backend="${yellow}Bitcoin Core$orange"

    source $pc
    if grep -q "electrs-end" $ic ; then choice="electrs" 
    elif grep -q "fulcrum-end" $ic ; then choice="Fulcrum" 
    elif grep -q "electrumx-end" $ic ; then choice="ElectrumX" 
    fi

    if [[ $prefersbitcoinmempool_only_ask_once == "true" ]] ; then choice="skip" ; fi
    
    case $choice in
    electrs|Fulcrum|ElectrumX)
    if yesorno "You have $choice installed. Do you want Mempool to sync up with that
    instead of Bitcoin Core directly? (It's better and faster)"  ; then
        change_mempool_backend
    else
        parmanode_conf_add "prefersbitcoinmempool_only_ask_once=true"
    fi
    ;;
    skip)
    true #do nothing
    esac


elif grep "MEMPOOL_BACKEND" < $hp/mempool/docker/docker-compose.yml | grep -q "electrum" ; then
export backend="${bright_blue}An Electrum/Fulcrum Server$orange"
else
export backend=""
fi

set_terminal_custom 45 ; echo -e "
########################################################################################$cyan
                                    Mempool Menu            $orange                   
########################################################################################


                        MEMPOOL BACKEND: $backend

$running


$cyan
               s)$orange           Start
$cyan
               stop)$orange        Stop
$cyan
               r)$orange           Restart
$cyan
               tor)$orange         Enable/Disable Tor.        $tor_mempool_status
$cyan
               conf)$orange        View/Edit config (confv for vim)$pink(restart if changing)$orange
$cyan
               bk)$orange          Change backend ...


    ACCESS MEMPOOL:
    
    Address only available on this computer's browser: 
$cyan    http://127.0.0.1:8180 $orange
    Address available on computers sharing your router:
$cyan    http://$IP:8180 $orange

$output_tor
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 

m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

start|S|s|Start|START)
start_mempool
;;
stop|STOP|Stop)
stop_mempool
;;

r|RESTART|restart|R)
restart_mempool
;;

tor)
file="$hp/mempool/docker/docker-compose.yml"
if [[ $tor_mempool == "false" ]] ; then
swap_string "$file" "SOCKS5PROXY_ENABLED:" "      SOCKS5PROXY_ENABLED: \"true\""
debug "check swap should be true"
enable_mempool_tor
else
swap_string "$file" "SOCKS5PROXY_ENABLED:" "      SOCKS5PROXY_ENABLED: \"false\""
debug "check swap should be false"
disable_mempool_tor
fi
unset file
;;

conf)
nano $hp/mempool/docker/docker-compose.yml
;;
confv)
vim $hp/mempool/docker/docker-compose.yml
;;

bk)
change_mempool_backend
;;

*)
invalid
;;

esac
done
}
