function delete_blockchain {
while true ; do
set_terminal ; echo -e "
########################################################################################

    You are about to delete the entire Bitcoin database.$Pink Be careful. $orange

    Do you wish to delete Bitcoin data on an internal drive or external drive?

        
        internal)       deletes data at $HOME/.bitcoin


        external)       deletes data at $parmanode_drive/.bitcoin 

########################################################################################
"
choose xpmq ; read choice
case $choice in

m|M) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;

internal) 
are_you_sure "Delete internal drive blockchain data?" || return 1 
if [[ ! -L $HOME/.bitocin ]] ; then 
please_wait && echo "The data will be deleted, and a customised bitcoin.conf will be made)"
rm -rf $HOME/.bitcoin/*
sleep 2
make_bitcoin_conf
success "Bitcoin data" "being deleted" && return 0
else
announce "No Bitcoin data at the expected location. Aborting." ; return 1
fi
;;

external) 
are_you_sure  "Delete external drive blockchain data?" || return 1
mount_drive || return 1
please_wait && echo "The data will be deleted, and a customised bitcoin.conf will be made)"
rm -rf $parmanode_drive/.bitcoin/* 
sleep 2
make_bitcoin_conf
debug "check conf file"
success "Bitcoin data" "being deleted" && return 0 ;;
*)
esac
done
}
