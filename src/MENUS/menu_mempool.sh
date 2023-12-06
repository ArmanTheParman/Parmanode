function menu_mempool {
while true ; do 

if docker ps 2>/dev/null | grep -q mempool_web ; then
running="              Mempool is$green Running$orange"
else
running="              Mempool is$red Not Running$orange"
fi

unset ONION_ADDR_MEM tor_mempool tor_mempool_status
if [[ -e /var/lib/tor/mempool-service ]] ; then
get_onion_address_variable mempool
tor_mempool_status="${green}enabled$orange"
tor_mempool=true
else
tor_mempool=false
tor_mempool_status="${red}disabled$orange"
fi


set_terminal ; echo -e "
########################################################################################$cyan
                                  Mempool Menu            $orange                   
########################################################################################

$running

                  s)             Start

                  stop)          Stop

                  r)             Restart

                  tor)           Enable/Disable Tor.                      $tor_mempool_status

                  bc)            Enable/Disable Bitcoin Core backend      $core_mempool_status 

                  e)             Enable/Disable Electrs backend           $electrs_mempool_status

                  f)             Enable/Disable Fulcrum backend           $fulcrum_mempool_status

                  c)             Enable/Disable Custom backend            $custom_mempool_status

                  conf)          View/Edit config (restart if changing)

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 

tor)
if [[ $mempool_tor == false ]] ; then
swap_string "$file" "SOCKS5PROXY_ENABLED:" "SOCKS5PROXY_ENABLED: \"true\""
enable_mempool_tor
else
swap_string "$file" "SOCKS5PROXY_ENABLED:" "SOCKS5PROXY_ENABLED: \"false\""
disable_mempool_tor
fi
;;

bc)



*)
invalid
;;

esac
done
}
