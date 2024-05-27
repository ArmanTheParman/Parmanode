function nostrrelay_run {

if [[ $nostr_drive == internal ]] ; then
nostr_data=$HOME/.nostr_data
elif [[ $nostr_drive == external ]] ; then
nostr_data=$pd/nostr_data
else
announce "error. no variable for drive set. Aborting."
exit
fi

docker run -du root -p 7080:8080 \
  -v $nostr_data:/usr/src/app/db \
  -v $HOME/parmanode/nostrrelay/config.toml:/usr/src/app/config.toml:ro \
  --name nostrrelay nostr-rs-relay:latest
}