function nostr_keys_byo {

while true ; do
set_terminal ; echo -e "
########################################################################################

    Get a 12 word seed from somewhere, eg Ian Coleman's BIP39 Webtool. Then type it
    in here, separated by spaces.
    $pink
    Please do not use the seed phrase of a real Bitcoin Wallet! That's bloody
    dangerous. $orange

########################################################################################
"
choose xpmq ; read mnemonic ; set_terminal
case $mnemonic in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)

if ! echo "$mnemonic" | wc -w | grep 12 ; then
set_terminal ; announce "Please enter exactly 12 words."
continue
fi

mkdir -p $dp/.nostr_keys
echo "$mnemonic" | tee $dp/.nostr_keys/mnemonic.txt

#Python code to confirm checksum is valid
make_nostr_key_files ; function_exit="$?"

if [[ $function_exit == 1 ]] ; then
    rm $dp/.nostr_keys/mnemonic.txt >/dev/null 2>&1
    announce "The checksum seems to be invalid."
    continue
elif [[ $function_exit == 0 ]] ; then
    announce "Please note, your mnemonic, nsec, and npub are kept unencrypted in the 
    hidden directory:$cyan $dp/.nostr_keys/ $orange

    Parmanode needs access to this directory to sign messages for you. Things will 
    stop working if you delete or move it."
    return 0
else
    rm $dp/.nostr_keys/mnemonic.txt >/dev/null 2>&1
    announce "Unexpected error. Please report to Parman."
    continue
fi
;;
esac
done

}