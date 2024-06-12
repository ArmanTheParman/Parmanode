function reindex_bitcoin {

set_terminal ; echo -e "
########################################################################################

    Re-index the blockchain? (This might take 7.5 million years)

    Type  $green  y$orange   or$red   n   $orange then <enter>

########################################################################################
"
read choice
if [[ $choice == y ]] ; then
stop_bitcoind
clear
echo -e "
########################################################################################

   Bitcoin will now re-index the blockchain. This will take a really long time.
   Keep this window open, and do not hit control-c, or it will abort.

   If you need a terminal window, you can open a new one; you can even run Parmanode
   on that concurrently.

   When it's done, Bitcoin will stop and start over to run in the background.

########################################################################################
"
enter_continue
clear
if grep -q "btccombo" < $ic ; then
docker exec btcpay bitcoind --reindex
docker exec btcpay bitcoin-cli stop
doecker exec -d btcpay bitcoind 
elif [[ $OS == Linux ]] ; then
sudo bitcoind --reindex
stop_bitcoind
start_bitcoind
fi

fi

}