function add_server_1_to_bitcoinconf {
if grep -q "bitcoin-end" $ic ; then
if ! grep -q "server=1" $bc ; then
set_terminal ; echo -e "
########################################################################################
    
    O Bitcoin precisa de ser reiniciado para adicionar a linha$cyan ' server=1'$orange ao ficheiro de configuração.

    Carregue em$red s$orange para saltar ouem$green qualquer outra coisa$orange para continuar e permitir que as alterações sejam efectuadas.

########################################################################################
"
read choice
if [[ $choice == "s" ]] ; then return ; fi

    stop_bitcoin
    echo "server=1" | tee -a $bc >$dn 2>&1
    start_bitcoin
fi
fi
}
