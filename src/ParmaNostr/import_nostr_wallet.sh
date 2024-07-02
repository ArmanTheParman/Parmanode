function import_nostr_wallet {

mkdir -p $dp/.nostr_keys/ 2>&1

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                        Import Nostr Keys to ParmaNostr
$orange
    Please paste your nsec, then hit $green<enter>$orange
$orange
########################################################################################
"
choose xpmq ; read nsec ; set_terminal
case $nsec in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)
if ! echo $nsec | cut -c 1-4 | grep -q nsec || ! [[ $(echo $nsec | wc -c | grep -Eo '[0-9]'+) == 64 ]] ; then
announce "Wrong format." "Needs to start with nsec followed by a long string, total 64 characters"
continue
fi

echo $nsec | tee $dp/.nostr_keys/nsec.txt >/dev/null 2>&1
make_nsec_bytes
make_pubkey
make_npub

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