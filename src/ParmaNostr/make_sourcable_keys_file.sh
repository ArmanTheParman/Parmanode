function make_sourcable_keys_file {

#shortcut to file is $nk
file="$dp/.nostr_keys/nostr_keys.txt"

pub="$(cat $dp/.nostr_keys/pub.txt | tr -d ' ')"
npub="$(cat $dp/.nostr_keys/npub.txt | tr -d ' ')"
nsec="$(cat $dp/.nostr_keys/nsec.txt | tr -d ' ')"
priv_hex="$(cat $dp/.nostr_keys/priv_hex.txt | tr -d ' ')"

echo "npub=$npub
nsec=$nsec
priv_hex=$priv_hex" | tee $file >/dev/null 2>&1

unset file
}