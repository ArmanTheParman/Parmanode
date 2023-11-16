function change_bitcoin_drive {
source $HOME/.parmanode/parmanode.conf
if [[ $drive == external ]] ; then otherdrive=internal ; fi
if [[ $drive == internal ]] ; then otherdrive=external ; fi

while true ; do
if [[ -z $1 ]] ; then #zero argument, called by menu_bitcoin_other to swap drives
set_terminal ; echo -e "
########################################################################################
$cyan
                          CHANGE BITCOIN SYNCING DRIVE          
$orange
    You are currently syncing blocks to the $drive drive. 

    Would you like to change and sync data to the $otherdrive drive?


                  c)       Change         (doesn't delete data)

                  n)       No, leave it    
 
########################################################################################
"
choose "xpmq"
read choice ; set_terminal
else choice=c     # when $ is "swap" but never possible because -z $1 necessary to enter block
fi

# argument "change" is called by mynode/rpb/umbrel import functions. A bitcoin
# drive argument may not be set. Set to "internal" to enter correct if blocks
if [[ -n $1 && $1 == change ]] ; then choice=c ; drive=internal ; fi 



case $choice in
m|M) back2main ;;
q|Q) exit ;;
p|P|n|N|NO|No) return 1 ;;

c|C)
 #change systemctl? No - because symlink

  stop_bitcoind

if [[ $drive == external ]] ; then

    # No backup, just leave drive as is.
    rm $HOME/.bitcoin #deletes symlink to external drive
    parmanode_conf_remove "drive=" && parmanode_conf_add "drive=internal"
    source $dp/parmanode.conf >/dev/null 2>&1
    mkdir $HOME/.bitcoin
    make_bitcoin_conf prune 0 #double check this
    announce "Start Bitcoin manually to begin syncing."
    return 0
fi


if [[ $OS == Mac && $drive == internal ]] ; then

    mount_drive || return 1
    if [[ ! -d $parmanode_drive/.bitcoin ]] ; then mkdir $parmanode_drive/.bitcoin ; fi

    parmanode_conf_remove "drive=" && parmanode_conf_add "drive=external"
    source $dp/parmanode.conf >/dev/null 2>&1
    if [[ ! -d $HOME/.bitcoin    &&    ! -L $HOME/.bitcoin ]] ; then
    make_bitcoin_symlinks
    fi

    if [[   -d $HOME/.bitcoin    &&    ! -L $HOME/.bitcoin ]] ; then
    make_backup_dot_bitcoin
    make_bitcoin_symlinks
    fi 

    make_bitcoin_conf prune 0
    announce "Start Bitcoin manually to begin syncing."
    return 0
        
fi

if [[ $drive == internal && $OS == Linux ]] ; then

while ! grep -q parmanode < /etc/fstab ; do

set_terminal ; echo -e "
########################################################################################

    It doesn't seem like you have imported a Parmanode drive. What would you like
    to do?

                  i)        Import an external drive

                  f)        Format a new drive 

                  a)        Abort, Abort!

########################################################################################
"
choose "xpmq"
read choice ; set_terminal
case $choice in
m|M) back2main ;;
q|Q) exit ;;
a|A|p|P|n|N|NO|No) return 1 ;;
i|I)
add_drive
;;
f|F)
format_ext_drive justFormat
;;
*)
invalid ;;
esac #ends import parmanode drive options
done # ends while no parmanode in fstab

#Once initial internal and now parmanode in fstab...
    parmanode_conf_remove "drive=" && parmanode_conf_add "drive=external"
    source $dp/parmanode.conf >/dev/null 2>&1
    make_backup_dot_bitcoin
    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin
    mkdir $parmanode_drive/.bitcoin >/dev/null 2>&1 && \
            log "bitcoin" ".bitcoin dir made on ext drive" 
    sudo chown -R $USER:$(id -gn) $parmanode_drive/.bitcoin
    make_bitcoin_conf prune 0
    announce "Start Bitcoin manually to begin syncing."
    return 0

fi  #ends if $drive=internal
;; 
*)
invalid ;;
esac # ends change it or leave it
done

}