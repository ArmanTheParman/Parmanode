function reindex_bitcoin {

set_terminal ; echo "
########################################################################################

    Re-index the blockchain? (This might take 7.5 million years)

    Type    y   or   n    then <enter>

########################################################################################
"
read choice
if [[ $choice == y ]] ; then
stop_bitcoind
sudo bitcoind --reindex
start_bitcoind
fi

}