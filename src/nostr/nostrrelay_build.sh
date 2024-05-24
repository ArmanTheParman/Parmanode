function nostrrelay_build {
cd nostrrelay
docker build --pull -t nostr-rs-relay .
}