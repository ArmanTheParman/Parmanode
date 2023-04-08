function menu_bitcoin-cli {

while true
do
set_terminal
echo "
########################################################################################

                                BITCOIN COMMANDS MENU

########################################################################################                                

                        v)            Version         

                        gi)           Get info            
                
                        ni)           Net info
                
                        gbh)          Get blockhash   
                
                        gbi)          Get blockchain info 
                
                        gdi)          Get deployment info
                
                        gd)           Get difficulty  
                
                        gmi)          Get mempool info    
                
                        gtosi)        Get tx out set info 
                                        
                        gcc)          Get connection count    
                
                        vm)           Verify a message


########################################################################################
"
read -p "Type in your choice, (p) for previous, or (q) to quit, then <enter> : " choice

clear
case $choice in

v|V)
    set_terminal
    /usr/local/bin/bitcoin-cli -version
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gi)
    set_terminal
    /usr/local/bin/bitcoin-cli -getinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
ni)
    set_terminal
    /usr/local/bin/bitcoin-cli -netinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gbh)  
    set_terminal
    read -p "Enter the block number you want the hash of... " block
    /usr/local/bin/bitcoin-cli getblockhash $block
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gbi)  
    set_terminal
    /usr/local/bin/bitcoin-cli getblockchaininfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gdi)  
    set_terminal
    /usr/local/bin/bitcoin-cli getdeploymentinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gd)  
    set_terminal
    /usr/local/bin/bitcoin-cli getdifficulty
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gmi)  
    set_terminal
    /usr/local/bin/bitcoin-cli getmempoolinfo
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gtosi)  
    set_terminal
    echo -n "
########################################################################################    

        Warning, this command takes a minute or two...

        It provides information about every UTXO on the blockchain. 

        What is a UTXO?  - see: " 
printf "\e]8;;%s\a%s\e]8;;\a" "https://armantheparman.com/utxo" "armantheparman.com: What is a UTXO?"
echo "


########################################################################################

waiting...

"
    /usr/local/bin/bitcoin-cli gettxoutsetinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    set_terminal
    continue
    ;;

gcc)
    set_terminal
    /usr/local/bin/bitcoin-cli getconnectioncount
    echo "
Hit <enter> to go back to the menu."
    read    
    set_terminal
    continue
    ;;

vm)  
    set_terminal
    read -p "Please paste in the ADDRESS and hit <enter> :" address
    echo ""
    read -p "Please paste in the SIGNATURE text and hit <enter> :" signature
    echo ""
    read -p "Please paste in the MESSAGE TEXT and hit <enter> : " message
    echo ""
    echo ""
    /usr/local/bin/bitcoin-cli verifymessage $address $signature $message
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
q|Q|quit)
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
