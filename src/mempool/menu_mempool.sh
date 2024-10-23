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
debug "after unset"
if sudo test -e /var/lib/tor/mempool-service ; then
debug "var lib tor mempool-service if exists"
get_onion_address_variable mempool
tor_mempool_status="${green}enabled$orange"
tor_mempool="true"
get_onion_address_variable "fulcrum" 
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



               s)           Start

               stop)        Stop

               r)           Restart

               tor)         Enable/Disable Tor.        $tor_mempool_status

               conf)        View/Edit config (confv for vim)$pink(restart if changing)$orange

               bk)          Change backend ...


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

# bk)
# mempool_backend
# ;;

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

function change_mempool_backend {
while true ; do
set_terminal
echo -e "
########################################################################################$cyan
                          CHOOSE A BACKEND FOR MEMPOOL$orange
########################################################################################


$green                 b) $orange       Bitcoin (simplest)

     $green            e) $orange       Electrum (You must make sure its running)

          $green       ex)      $orange Electrum X (You must make sure its running)

               $green  f)     $orange   Fulcrum (You must make sure its running)


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

b|B|Bitcoin|bitcoin)
choose_bitcoin_for_mempool
restart_mempool
break
;;

e|E)
choose_electrs_for_mempool
restart_mempool
break
;; 

f|F)
choose_fulcrum_for_mempool
restart_mempool
break
;;

*)
invalid
;;
esac
done

}



function choose_bitcoin_for_mempool {
export file="$hp/mempool/docker/docker-compose.yml"
swap_string "$file" ' MEMPOOL_BACKEND:' "      MEMPOOL_BACKEND: \"none\""
unset file
}

function choose_electrs_for_mempool {
export file="$hp/mempool/docker/docker-compose.yml"
swap_string "$file" ' MEMPOOL_BACKEND:' "      MEMPOOL_BACKEND: \"electrum\"" 
swap_string "$file" ' ELECTRUM_PORT:' "      ELECTRUM_PORT: \"50005\"" 
unset file
}

function choose_fulcrum_for_mempool {
export file="$hp/mempool/docker/docker-compose.yml"
swap_string "$file" ' MEMPOOL_BACKEND:' "      MEMPOOL_BACKEND: \"electrum\"" 
swap_string "$file" ' ELECTRUM_PORT:' "      ELECTRUM_PORT: \"50001\""
unset file
}