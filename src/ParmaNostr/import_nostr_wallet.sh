function import_nostr_wallet {

mkdir -p $dp/.nostr_keys/ 2>&1

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                        Import Nostr Keys to ParmaNostr

$orange
    Please paste either your nsec or hex private key, then hit $green<enter>$orange


    eg nsec:$bright_blue nsec1f6ufppn9u0mcp33lup4huk68f43vcx0xej4nelvld5gny80azceqd3w343 $orange

    eg hex: $bright_blue e8f3e434ed5f0dede763c524e0a6b6d498544e84c9f65cd1447bd82e9fa4b913 $orange
$orange

########################################################################################
"
choose xpmq ; read nsec ; set_terminal
unset typedetected
case $nsec in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)
while true ; do
if echo -n "$nsec" | cut -c 1-4 | grep -q nsec && [[ $(echo -n $nsec | wc -c | tr -d ' ' | tr -d '\n') == 64 ]] ; then
typedetected=nsec
debug "typedetected , $typedetected "
break
fi

if [[ $(echo -n "$nsec" | grep -oE '[0-9|a-f|A-F]+' | tr -d '\n' | wc -c | tr -d ' ') == 64 ]] ; then
typedetected=hex
debug "typedetected , $typedetected "
break
fi

announce "Wrong format." "Expecting nsec, or 64 character HEX format (no 0x prefix)."
continue 2

done


if [[ $typedetected == nsec ]] ; then
echo $nsec | tee $dp/.nostr_keys/nsec.txt >/dev/null 2>&1
make_nsec_bytes
make_pubkey
make_npub
make_priv_hex
fi

if [[ $typedetected == hex ]] ; then
echo $nsec | tee $dp/.nostr_keys/priv_hex.txt >/dev/null 2>&1
make_priv_hex_bytes
make_pubkey
make_npub
make_nsec
debug "after make nsec"
fi

set_terminal ; echo -e "
########################################################################################

    Your wallet has been imported to: $cyan

        $dp/.nostr_keys/
$orange
    The npub for your wallet is: $cyan

        $(cat $dp/.nostr_keys/npub.txt)
$orange
    The nsec for your wallet is: $cyan

        $(cat $dp/.nostr_keys/nsec.txt)
$orange
########################################################################################
"
enter_continue
break
;;
esac
done


}