function menu_bitcoin_cli {
while true
do
set_terminal
echo -e "
########################################################################################

                                BITCOIN COMMANDS MENU

########################################################################################                                


                        (v)            Version         

                        (gi)           Get info            
                
                        (ni)           Net info
                
                        (gbh)          Get blockhash   
                
                        (gbi)          Get blockchain info 
                
                        (gdi)          Get deployment info
                
                        (gd)           Get difficulty  
                
                        (gmi)          Get mempool info    
                
                        (gtosi)        Get tx out set info 
                                        
                        (gcc)          Get connection count    
                
                        (vm)           Verify a message


########################################################################################
"
choose "xpmq"
read choice
clear
case $choice in
m|M) back2main ;;

v|V)
if [[ $OS == Mac ]] ; then echo "see GUI." ; enter_continue ; continue ; fi

    set_terminal
    /usr/local/bin/bitcoin-cli -version
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gi)
if [[ $OS == Mac ]] ; then no_mac ; continue ; fi
    set_terminal
    /usr/local/bin/bitcoin-cli -getinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
ni)
if [[ $OS == Mac ]] ; then no_mac ; continue ; fi
    set_terminal
    /usr/local/bin/bitcoin-cli -netinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gbh)  

if [[ $OS == Mac ]] ; then no_mac ; continue ; fi
    set_terminal
    read -p "Enter the block number you want the hash of... " block
    /usr/local/bin/bitcoin-cli getblockhash $block
    enter_continue
    continue
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
    set_terminal ; echo "
########################################################################################    

         Warning, this command takes a minute or two...

         It provides information about every UTXO on the blockchain. 

         What is a UTXO?  - see: https://armantheparman.com/utxo

########################################################################################
"
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
if [[ $OS == Mac ]] ; then no_mac ; fi

    set_terminal
    read -p "Please paste in the ADDRESS and hit <enter> :" address
    echo ""
    read -p "Please paste in the SIGNATURE text and hit <enter> :" signature
    echo ""
    read -p "Please paste in the MESSAGE TEXT and hit <enter> : " message
    echo ""
    echo ""
   /usr/local/bin/bitcoin-cli verifymessage "$address" "$signature" "$message" 
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
q|Q|quit|Quit)
    set_terminal
    exit 0
    ;;
p)
    set_terminal
    return 0
    ;;
*)
    set_terminal
    Invalid
    continue
    ;;
esac
done
}
