function parmanostr_wallet_info {

while true ; do
set_terminal ; echo -e "
########################################################################################$cyan
                              ParmaNostr Wallet Info$orange
########################################################################################
$orange


                 seed)               See seed words

                 nsec)               See private key

                 del)                Delete wallet

    

    npub (public key)   $cyan
    $(cat $dp/.nostr_keys/npub.txt) $orange


$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
seed)
announce "Your seed words are:
$cyan
    $(cut -d ' ' -f 1-6 $dp/.nostr_keys/mnemonic.txt)
    $(cut -d ' ' -f 7-12 $dp/.nostr_keys/mnemonic.txt)$orange "
;;
del)
unset enter_cont
announce "Are you sure you want to uninstall ParmaNostr and delete 
    your Nostr Keys??? $red y$orange or$green n$orange"
if [[ $enter_cont == y ]] ; then
sudo rm -rf $dp/.nostr_keys && installed_conf_remove "parmanostr" && success "Nostr keys destroed" && back2main
fi
;;
nsec)
announce "Your nsec (private key) is:
$cyan
    $(cat $dp/.nostr_keys/nsec.txt) $orange"
;;
*)
invalid
;;
esac
done
}