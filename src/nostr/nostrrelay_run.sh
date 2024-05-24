function nostrrelay_run {
docker run -du root -p 7080:8080 \
  -v $HOME/.nostr_data:/usr/src/app/db \
  -v $HOME/parmanode/nostrrelay/config.toml:/usr/src/app/config.toml:ro \
  --name nostrrelay nostr-rs-relay:latest
}