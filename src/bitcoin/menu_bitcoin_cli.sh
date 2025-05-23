function menu_bitcoin_cli {
source $bc

if grep -q "btccombo" $ic ; then combomenu="true" ; else unset combomenu ; fi

while true
do
set_terminal
echo -e "
########################################################################################
$cyan
                                BITCOIN COMMANDS MENU
$orange
########################################################################################                                

$cyan
                        (v)$orange            Version         
$cyan
                        (gi)$orange           Get info            
    $cyan            
                        (ni)$orange           Net info
        $cyan        
                        (gbh)$orange          Get blockhash   
            $cyan    
                        (gbi)$orange          Get blockchain info 
               $cyan 
                        (gdi)$orange          Get deployment info
               $cyan 
                        (gd)$orange           Get difficulty  
               $cyan 
                        (gmi)$orange          Get mempool info    
               $cyan 
                        (gtosi)$orange        Get tx out set info 
                   $cyan                     
                        (gcc)$orange          Get connection count    
               $cyan 
                        (vm)$orange           Verify a message


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
clear
case $choice in
m|M) back2main ;;

v|V)
if [[ $combomenu == "true" ]] ; then
set_terminal
docker exec btcpay bitcoin-cli --version
enter_continue
continue
elif [[ $OS == Linux ]] ; then
set_terminal
/usr/local/bin/bitcoin-cli -version
enter_continue
continue
fi
;;

gi)
if [[ $combomenu == "true" ]] ; then
set_terminal
docker exec btcpay bitcoin-cli -getinfo
enter_continue
continue
elif [[ $OS == Linux ]] ; then
set_terminal
/usr/local/bin/bitcoin-cli -getinfo
enter_continue
continue
elif [[ $OS == Mac ]] ; then no_mac ; continue 
fi
;;

ni)
if [[ $combomenu == "true" ]] ; then
set_terminal
docker exec btcpay bitcoin-cli -netinfo
enter_continue
continue
elif [[ $OS == Linux ]] ; then
set_terminal
/usr/local/bin/bitcoin-cli -netinfo
enter_continue
continue
elif [[ $OS == Mac ]] ; then no_mac ; continue 
else announce "some error - Linux nor Mac detected." ; continue
fi
;;
gbh)  
set_terminal
echo "Enter the block number you want the hash of... " 
read block ; set_terminal

if [[ $combomenu == "true" ]] ; then
set_terminal
docker exec btcpay bitcoin-cli getblockhash $block
enter_continue
continue
elif [[ $OS == Linux ]] ; then
set_terminal
/usr/local/bin/bitcoin-cli getblockhash $block
enter_continue
continue
elif [[ $OS == Mac ]] ; then no_mac ; continue 
else announce "some error - Linux nor Mac detected." ; continue
fi
;;   

gbi)  

if [[ $OS == Mac ]] ; then
curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/
enter_continue
continue
fi
    set_terminal
    /usr/local/bin/bitcoin-cli getblockchaininfo
    enter_continue
    continue
    ;;

gdi)  
if [[ $OS == Mac ]] ; then
curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getdeploymentinfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/
enter_continue
continue
fi

    set_terminal
    /usr/local/bin/bitcoin-cli getdeploymentinfo
    enter_continue
    continue
    ;;
gd)  

if [[ $OS == Mac ]] ; then
curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getdifficulty", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/
enter_continue
continue
fi

    set_terminal
    /usr/local/bin/bitcoin-cli getdifficulty
    enter_continue
    continue
    ;;
gmi)  

if [[ $OS == Mac ]] ; then
curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getmempoolinfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/
enter_continue
continue
fi

    set_terminal
    /usr/local/bin/bitcoin-cli getmempoolinfo
    enter_continue
    continue
    ;;
gtosi)  
    set_terminal ; echo -e "
########################################################################################    

         Warning, this command takes a minute or two...

         It provides information about every UTXO on the blockchain. 

         What is a UTXO?  - see:$cyan https://armantheparman.com/utxo $orange

########################################################################################
"
enter_continue ; jump $enter_cont

please_wait

if [[ $OS == Mac ]] ; then
curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "gettxoutsetinfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/
enter_continue
continue
fi
    /usr/local/bin/bitcoin-cli gettxoutsetinfo
    enter_continue
    set_terminal
    continue
    ;;

gcc)
if [[ $OS == Mac ]] ; then
curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getconnectioncount", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:8332/
enter_continue
continue
fi
    set_terminal
    /usr/local/bin/bitcoin-cli getconnectioncount
    enter_continue
    set_terminal
    continue
    ;;

vm)  
if [[ $combomenu == "true" ]] ; then

    set_terminal
    echo "Please paste in the ADDRESS and hit <enter> :" ; read address
    echo ""
    echo "Please paste in the SIGNATURE text and hit <enter> :" ; read signature
    echo ""
    echo "Please paste in the MESSAGE TEXT and hit <enter> : " ; read message
    echo ""
    echo ""
    docker exec btcpay bitcoin-cli verifymessage "$address" "$signature" "$message" 
    enter_continue
    continue
elif [[ $OS == Linux ]] ; then
    set_terminal
    read -p "Please paste in the ADDRESS and hit <enter> :" address
    echo ""
    read -p "Please paste in the SIGNATURE text and hit <enter> :" signature
    echo ""
    read -p "Please paste in the MESSAGE TEXT and hit <enter> : " message
    echo ""
    echo ""
    bitcoin-cli verifymessage "$address" "$signature" "$message" 
    enter_continue
    continue
elif [[ $OS == Mac ]] ; then no_mac ; continue 
else announce "some error - Linux nor Mac detected." ; continue
fi
;;
q|Q|quit|Quit)
    set_terminal
    exit 0
    ;;
p)
    set_terminal
    return 0
    ;;
"")
continue ;;
*)
    set_terminal
    Invalid
    continue
    ;;
esac
done
}
