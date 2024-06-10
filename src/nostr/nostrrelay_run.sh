function nostrrelay_run {

if [[ $drive_nostr == internal ]] ; then
nostr_data=$HOME/.nostr_data

elif [[ $drive_nostr == external ]] ; then
nostr_data=$pd/nostr_data

elif [[ $drive_nostr == custom ]] ; then
nostr_data=$drive_nostr_custom_data

else
announce "error. no variable for drive set. Aborting."
exit

fi

docker run -du root -p 7080:8080 \
  --restart unless-stopped \
  -v $nostr_data:/usr/src/app/db \
  -v $HOME/parmanode/nostrrelay/config.toml:/usr/src/app/config.toml:ro \
  --name nostrrelay nostr-rs-relay:latest
}