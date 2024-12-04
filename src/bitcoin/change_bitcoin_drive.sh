function change_bitcoin_drive {
source $HOME/.parmanode/parmanode.conf
if [[ $drive == external ]] ; then otherdrive=internal ; fi
if [[ $drive == internal ]] ; then otherdrive=external ; fi

while true ; do
if [[ -z $1 ]] ; then #zero argument, called by menu_bitcoin_other to swap drives
set_terminal ; echo -e "
########################################################################################
$cyan
                          ALTERAR A DRIVE DE SINCRONIZAÇÃO DE BITCOIN          
$orange
    Atualmente, está a sincronizar blocos com a drive$drive.

    Gostaria de alterar e sincronizar dados para a drive$otherdrive?


                  c)       Alterar        (não elimina dados)

                  n)       Não, deixe estar    
 
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
else choice=c     # when $ is "swap" but never possible because -z $1 necessary to enter block
fi

# argument "change" is called by mynode/rpb/umbrel import functions. A bitcoin
# drive argument may not be set. Set to "internal" to enter correct if blocks
if [[ -n $1 && $1 == change ]] ; then choice=c ; drive=internal ; fi 


case $choice in
m|M) back2main ;; q|Q) exit ;; p|P|n|N|NO|No) return 1 ;;

c|C)
 #change systemctl? No - because symlink

  stop_bitcoin

if [[ $drive == external ]] ; then

    # No backup, just leave drive as is.
    rm $HOME/.bitcoin #deletes symlink to external drive
    parmanode_conf_remove "drive=" 
    parmanode_conf_add "drive=internal"
    source $dp/parmanode.conf >$dn 2>&1
    mkdir $HOME/.bitcoin
    make_bitcoin_conf prune 0 #double check this
    announce "Iniciar o Bitcoin manualmente para iniciar o sincronismo."
    return 0
fi


if [[ $OS == Mac && $drive == internal ]] ; then

    mount_drive || return 1
    if [[ ! -d $parmanode_drive/.bitcoin ]] ; then mkdir $parmanode_drive/.bitcoin ; fi

    parmanode_conf_remove "drive=" 
    parmanode_conf_add "drive=external"
    source $dp/parmanode.conf >$dn 2>&1
    if [[ ! -d $HOME/.bitcoin    &&    ! -L $HOME/.bitcoin ]] ; then
    make_bitcoin_symlinks
    fi

    if [[   -d $HOME/.bitcoin    &&    ! -L $HOME/.bitcoin ]] ; then
    make_backup_dot_bitcoin
    make_bitcoin_symlinks
    fi 

    make_bitcoin_conf prune 0
    announce "Iniciar o Bitcoin manualmente para iniciar o sincronismo."
    return 0
        
fi

if [[ $drive == internal && $OS == Linux ]] ; then

while ! grep -q parmanode < /etc/fstab ; do

set_terminal ; echo -e "
########################################################################################

    Não me parece que tenha importado uma drive Parmanode. 
    O que é que gostaria de fazer?
$cyan
                  i)$orange        Importar uma drive externa
$cyan
                  f)$orange        Formatar uma nova drive
$cyan
                  a)$orange        Abortar, Abortar!

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;; q|Q) exit ;; a|A|p|P|n|N|NO|No) return 1 ;;
i|I)
export make_label=parmanode && add_drive || return 1
;;
f|F)
export justFormat="true" && format_ext_drive 
;;
*)
invalid ;;
esac #ends import parmanode drive options
done # ends while no parmanode in fstab

#Once initial internal and now parmanode in fstab...
    parmanode_conf_remove "drive=" 
    parmanode_conf_add "drive=external"
    source $dp/parmanode.conf >$dn 2>&1
    make_backup_dot_bitcoin
    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin
    mkdir $parmanode_drive/.bitcoin >$dn 2>&1 && \
            log "bitcoin" "diretorio .bitcoin criado na drive externa" 
    sudo chown -R $USER:$(id -gn) $parmanode_drive/.bitcoin
    make_bitcoin_conf prune 0
    announce "Iniciar o Bitcoin manualmente para iniciar o sincronismo."
    return 0

fi  #ends if $drive=internal
;; 
*)
invalid ;;
esac # ends change it or leave it
done

}
