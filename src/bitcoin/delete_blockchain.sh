function delete_blockchain {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Estás prestes a apagar toda a base de dados Bitcoin.$Pink Tem cuidado. $orange

    Pretende apagar os dados do Bitcoin numa drive interna ou numa drive externa?

$cyan        
        interna)$orange       elimina dados em $HOME/.bitcoin

$cyan
        externa)$orange       elimina os dados em $parmanode_drive/.bitcoin 

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in

m|M) back2main ;; q|Q) exit ;; p|P) return 1 ;;

internal) 
are_you_sure "Eliminar os dados da blockchain da drive interna?" || return 1 
if [[ ! -L $HOME/.bitcoin ]] ; then 
please_wait && echo "Os dados serão eliminados e será criado um bitcoin.conf personalizado"
sudo rm -rf $HOME/.bitcoin/*
sleep 2
make_bitcoin_conf
success "Dados Bitcoin" "a serem eliminados" && return 0
else
announce "Não há dados Bitcoin no local esperado. Abortar." ; return 1
fi
;;

external) 
are_you_sure  "Eliminar os dados da blockchain da drive externa?" || return 1
mount_drive || return 1
please_wait && echo "Os dados serão eliminados e será criado um bitcoin.conf personalizado"
sudo rm -rf $parmanode_drive/.bitcoin/* 
sleep 2
make_bitcoin_conf
debug "check conf file"
success "Dados Bitcoin" "a serem eliminados" && return 0 ;;
*)
esac
done
}
