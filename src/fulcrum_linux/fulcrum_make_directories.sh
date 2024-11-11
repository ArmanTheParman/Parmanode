function fulcrum_make_directories {

mkdir $HOME/.fulcrum >$dn 2>&1

if [[ $drive_fulcrum == "external" ]] ; then

    if ! mount | grep parmanode >$dn ; then mount_drive ; fi

    #on the external drive itself...
    if [[ ! -d $pd/fulcrum_db ]] ; then mkdir -p $pd/fulcrum_db >$dn 2>&1 ; fi
    
    #if internal fulcrum_db dir previously exists... (move or delete choice)
    if [[ -d $HOME/.fulcrum_db && ! -L $HOME/.fulcrum_db ]] ; then
    fulcrum_db_exists || return 1
    fi

    #remove any symlinks
    if [[ -L $HOME/.fulcrum_db ]] ; then rm $HOME/.fulcrum_db >$dn 2>&1 ; fi #won't delete any dir because no '-rf' option

    #only make a symlink if there is no dir there
    if [[ ! -d $HOME/.fulcrum_db ]] ; then
        ln $pd/fulcrum_db $HOME/.fulcrum_db >$dn 2>&1
    fi

elif [[ $drive_fulcrum == "internal" ]] ; then

    mkdir -p $HOME/.fulcrum_db >$dn 2>&1

fi

return 0
}

function fulcrum_db_exists {
while true ; do
set_terminal ; echo -e "
########################################################################################

    A fulcrum databas directory already exists on the internal drive at  $cyan
    $HOME/.fulcrum_db. $orange

    It has a size of$cyan $(du -sh $HOME/.fulcrum_db | awk '{print $1}') $orange

    You have choices:
$red
                  d)     Delete the data
$green
                  mm)    Move it to a backup (fulcrum_db_backup)
$cyan
                  a)     Abort
$orange

########################################################################################
"
choose xmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; m|M|a) back2main ;; 
d)
sudo rm -rf $HOME/.fulcrum_db 
break
;;
mm)
sudo rm -rf $HOME/.fulcrum_db_backup
sudo mv $HOME/.fulcrum_db $HOME/.fulcrum_db_backup
break
;;
*)
invalid
esac
done
}
