function mempool_backend {

while true ; do

set_terminal ; echo -e "
########################################################################################
$cyan
               To what would you like Mempool to connect to for its data?
$orange

                    1)      Bitcoin Core (on this computer)

                    2)      Electrs (on this computer)

                    3)      Fulcrum (on this computer)
    
                    4)      Bitcoin Core (another computer)

                    5)      Any type of Electrum Server (another computer)

########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit ;;
p|P) return 1 ;;
m|M) back2main ;;

1)
choose_bitcoin_for_mempool
break
;;

2)
choose_electrs_for_mempool
break
;;

3)
choose_fulcrum_for_mempool
break
;;

4)
remote_bitcoin_for_mempool
break
;;

5)
remote_electrumserver_for_mempool
break
;;

*) invalid ;;
esac

return 0
}

function remote_bitcoin_for_mempool {
clear ; echo -e "
########################################################################################

    Please type in the IP address of the Bitcoin Core instance you want to use, then
    hit <enter>

########################################################################################
"
read ipcore

swap_string "$file" "MEMPOOL_BACKEND:" "MEMPOOL_BACKEND: \"none\""
swap_string "$file" "CORE_RPC_HOST:" "CORE_RPC_HOST: \"$ipcore\""

clear ; echo -e "
########################################################################################    
   $cyan 
    RPCUSER (username) for the chosen Bitcoin Core instance...
$orange
    This can be found in it's corresponding bitcoin.conf file. If it doesn't exist,
    then Bitcoin Core doesn't have a username set up. Parmanode won't be able to
    connect Mempool without it.
   $green 
    Type in the username then <enter>
$red
    Or type a then <enter> to abort
$orange
########################################################################################

"
read user
case $user in a) return 1 ;; esac
clear
echo -e "
########################################################################################

   Now type in the rpcpassword (found in the corresponding bitcoin.conf file) then
   hit <enter>

########################################################################################
"
read pass

swap_string "$file" "CORE_RPC_USERNAME:" "CORE_RPC_USERNAME: \"$user\""
swap_string "$file" "CORE_RPC_PASSWORD:" "CORE_RPC_PASSWORD: \"$pass\""
}

function remote_electrumserver_for_mempool {

swap_string "$file" "MEMPOOL_BACKEND:" "MEMPOOL_BACKEND: \"electrum\""

clear
echo -e "
########################################################################################

    Please type in the IP address of the computer where the target Electrum or Fulcrum
    server is, then hit <enter>.
    
########################################################################################
"
read eIP
clear

while true ; do
echo -e "
########################################################################################

    Do you want to use TCP or SSL?

                                1)      TCP

                                2)      SSL
    
########################################################################################
"
choose "x"
read eprotocol
case $eprotocol in
1) eprotocol=true ; break ;;
2) eprotocol=false ; break ;;
*) invalid ;;
esac
done

clear

echo -e "
########################################################################################

    Please type in the port number of the computer where the target Electrum or 
    Fulcrum server is, then hit <enter>.
    
    Typically this is 50001 for TCP and 50002 for SSL (pls match your previous choice)
    
########################################################################################
"
read eport
clear

swap_string "$file" "ELECTRUM_HOST:" "ELECTRUM_HOST: \"$eIP\""
swap_string "$file" "ELECTRUM_PORT:" "ELECTRUM_PORT: \"$eport\""
swap_string "$file" "ELECTRUM_TLS_ENABLED:" "ELECTRUM_TLS_ENABLED: \"$eprotocol\""

}

function choose_bitcoin_for_mempool {
swap_string "$file" "MEMPOOL_BACKEND:" "MEMPOOL_BACKEND: \"none\""
}
function choose_electrs_for_mempool {
swap_string "$file" "MEMPOOL_BACKEND:" "MEMPOOL_BACKEND: \"electrum\"" 
swap_string "$file" "ELECTRUM_PORT:" "ELECTRUM_PORT: \"50005\"" #redundant as 50005 is the default in the template
}
function choose_fulcrum_for_mempool {
swap_string "$file" "MEMPOOL_BACKEND:" "MEMPOOL_BACKEND: \"electrum\"" 
swap_string "$file" "ELECTRUM_PORT:" "ELECTRUM_PORT: \"50001\""
}