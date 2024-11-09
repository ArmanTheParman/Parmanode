function fulcrum_make_directories {

# Make parmanode/fulcrum directory on internal drive
mkdir $HOME/parmanode/fulcrum >/dev/null 2>&1 

if [[ $fulcrumdocker="true" ]] ; then
    mkdir $HOME/parmanode/fulcrum/config >/dev/null 2>&1
fi

#External drive DB directory
if [[ $drive_fulcrum == "external" ]] ; then

    if ! mount | grep parmanode ; then mount_drive ; fi
    if [[ ! -d $pd/fulcrum_db ]] ; then mkdir -p $parmanode_drive/fulcrum_db >$dn 2>&1 ; fi

elif [[ $drive_fulcrum == "internal" ]] ; then

    mkdir -p $HOME/.fulcrum_db >$dn 2>&1

fi
}

