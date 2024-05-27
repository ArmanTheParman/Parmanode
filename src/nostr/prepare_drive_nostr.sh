function prepare_drive_nostr {

if [[ $drive_nostr == "internal" ]] ; then
        mkdir -p $HOME/.nostr_data && return 0
        #move backed up db directory here later if selected
fi


if [[ $drive_nostr == "external" ]] ; then
 return 0
 # drive preparation done in "restore_nostr_drive" 
fi  
}