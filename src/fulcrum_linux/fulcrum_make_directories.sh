function fulcrum_make_directories {

mkdir $HOME/.fulcrum >$dn 2>&1

if [[ $drive_fulcrum == "external" ]] ; then

    if ! mount | grep parmanode ; then mount_drive ; fi

    if [[ ! -d $pd/fulcrum_db ]] ; then mkdir -p $pd/fulcrum_db >$dn 2>&1 ; fi

    if [[ -L $HOME/.fulcrum_db ]] ; then rm $HOME/.fulcrum_db >$dn 2>&1 ; fi

    if [[ ! -d $HOME/.fulcrum_db ]] ; then
        ln $dp/fulcrum_db $HOME/.fulcrum_db >$dn 2>&1
    fi

elif [[ $drive_fulcrum == "internal" ]] ; then

    mkdir -p $HOME/.fulcrum_db >$dn 2>&1

fi

}