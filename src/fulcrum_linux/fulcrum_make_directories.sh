function fulcrum_make_directories {

mkdir -p $HOME/parmanode/fulcrum/config >$dn 2>&1
mkdir $HOME/.fulcrum >$dn 2>&1

#External drive DB directory
if [[ $drive_fulcrum == "external" ]] ; then

    if ! mount | grep parmanode ; then mount_drive ; fi
    if [[ ! -d $pd/fulcrum_db ]] ; then mkdir -p $parmanode_drive/fulcrum_db >$dn 2>&1 ; fi

elif [[ $drive_fulcrum == "internal" ]] ; then

    mkdir -p $HOME/.fulcrum_db >$dn 2>&1

fi
}

