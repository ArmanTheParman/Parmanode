function fulcrum_make_directories {

# Make parmanode/fulcrum directory on internal drive
mkdir $HOME/parmanode/fulcrum >/dev/null 2>&1 
installed_config_add "fulcrum-start"

#Make config directory for docker; useful now or later
mkdir $HOME/parmanode/fulcrum/config 2>&1

#move internal db drive from old installation if it exists, and destination doesn't
if [[ -d $HOME/parmanode/fulcrum_db && ! -d $HOME/.fulcrum_db ]] ; then
please_wait
sudo mv $HOME/parmanode/fulcrum_db $HOME/.fulcrum_db >/dev/null 2>&1
fi

#External drive DB directory
if [[ $drive_fulcrum == "external" ]] ; then
mount_drive && log "fulcrum" "Drive mounted."
mkdir $parmanode_drive/fulcrum_db >/dev/null 2>&1 
fi

#Internal drive DB directory
if [[ $drive_fulcrum == "internal" ]] ; then
mkdir $HOME/.fulcrum_db >/dev/null 2>&1
log "fulcrum" "fulcrum_db made - internal" 
fi
}

