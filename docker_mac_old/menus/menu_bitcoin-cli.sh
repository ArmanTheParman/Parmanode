function menu_bitcoin_cli {

while true
do
clear
echo "

Bitcoin-cli commands menu:

                1)        Version         
        
                2)        Get info            
        
                3)        Net info
        
                4)        Get blockhash   
        
                5)        Get blockchain info 
        
                6)        Get deployment info
        
                7)        Get difficulty  
        
                8)        Get mempool info    
        
                9)        Get tx set out info 
                            - this is info about every UTXO on the blockchain) What is a UTXO?
                            - see: https://armantheparman.com/utxo
        
                10)      Get connection count    
        
                11)      Verify a message

"
read -p "Choose 1 to 11, p for previous, or q to quit, then <enter>" choice

clear
case $choice in

1)
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli -version
    echo "
    Hit <enter> to go back to the menu."
    read
    ;;
2)
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli -getinfo
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
3)
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli -netinfo
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
4)  
    clear
    read -p "Enter the block number you want the hash of... " block
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli getblock hash $block
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
5)  
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli getblockchaininfo
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
6)  
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli getdeploymentinfo
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
7)  
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli getdifficulty
    echo "
    Hit <enter> to go back to the menu."
    read
    ;;
8)  
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli getmempoolinfo
    echo "
    Hit <enter> to go back to the menu."
    read
    ;;
9)  
    clear
    echo "Warning, this command takes a minute or two..."
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli gettxsetoutinfo
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
10)  
    clear
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli getconnectioncount
    echo "
    Hit <enter> to go back to the menu."
    read    
    ;;
11)  
    clear
    read -p "Please paste in the address and hit <enter> :" address
    echo ""
    read -p "Please paste in the signature text and hit <enter> :" signature
    echo ""
    read -p "Please paste in the message text and hit <enter> : " message
    echo ""
    sudo docker exec parmanode_bitcoin_container /home/parman/bitcoin/bin/bitcoin-cli verifymessage $address $signature $message
    echo "
    Hit <enter> to go back to the menu."
    read    ;;
q | Q | quit)
    clear
    exit 0
    ;;
p)
    clear
    return 0
    ;;
*)
    echo "Invalid entry, hit <enter> to try again. " ; read
    ;;
esac
done
}