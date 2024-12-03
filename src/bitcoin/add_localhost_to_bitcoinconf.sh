# Earlier versions of parmanode didn't have this line in bitcoin conf, so just 
# making sure it's in there. If not, it skips.

function add_localhost_to_bitcoinconf {
if grep -q bitcoin-end $HOME/.parmanode/installed.conf ; then
if ! cat $HOME/.bitcoin/bitcoin.conf | grep "rpcallowip=127.0.0.1" >$dn 2>&1 ; then
    set_terminal
echo -e "
########################################################################################
    
    O Bitcoin precisa ser reiniciado para adicionar a linha
    
    $cyan \ "rpcallowip=127.0.0.1\"$orange ao arquivo de configuração. 
    
    Prima$red s$orange para saltar ou$green qualquer outra coisa$cyan para continuar e permitir que as alterações sejam efectuadas.

########################################################################################
"
    read choice

    if [[ $choice == "s" ]] ; then return ; fi

    stop_bitcoin
    echo "rpcallowip=127.0.0.1" | tee -a $HOME/.bitcoin/bitcoin.conf >$dn 2>&1
    start_bitcoin
fi
fi
}

