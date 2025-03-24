function nostrrelay_build {
cd nostrrelay
podman build --pull -t nostr-rs-relay .
}