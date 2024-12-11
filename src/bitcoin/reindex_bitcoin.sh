function reindex_bitcoin {

set_terminal ; echo -e "
########################################################################################

    Re-indexar a blockchain? (Isto pode demorar 7,5 milhões de anos)

    Digite $green y$orange ou$red n $orange e depois <enter>

########################################################################################
"
read choice
if [[ $choice == y ]] ; then
stop_bitcoin
clear
echo -e "
########################################################################################

   O Bitcoin agora vai reindexar o blockchain. Isso vai levar muito tempo. Mantém esta 
   janela aberta e não carregues em control-c, ou o processo será interrompido.

   Se precisar de uma janela de terminal, pode abrir uma nova janela; pode até correr 
   o Parmanode nessa janela ao mesmo tempo.

   Quando terminar, o Bitcoin pára e recomeça a funcionar em segundo plano.

########################################################################################
"
enter_continue
clear
if grep -q "btccombo" $ic ; then
docker exec btcpay bitcoind --reindex
docker exec btcpay bitcoin-cli stop
docker exec -d btcpay bitcoind 
elif [[ $OS == Linux ]] ; then
sudo bitcoind --reindex
stop_bitcoin
start_bitcoin
fi

fi

}
