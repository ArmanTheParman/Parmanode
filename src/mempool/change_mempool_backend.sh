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

ex)
choose_electrumx_for_mempool
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

function choose_electrumx_for_mempool {
export file="$hp/mempool/docker/docker-compose.yml"
swap_string "$file" ' MEMPOOL_BACKEND:' "      MEMPOOL_BACKEND: \"electrum\"" 
swap_string "$file" ' ELECTRUM_PORT:' "      ELECTRUM_PORT: \"50007\"" 
unset file
}