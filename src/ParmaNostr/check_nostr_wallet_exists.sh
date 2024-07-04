function check_nostr_wallet_exists {
if [[ -d $dp/.nostr_keys ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$red
    Nostr Key directory detected
$orange
$cyan               1)$orange Use it

$cyan               2)$orange Delete and start over

$cyan               3)$orange Back it up to $dp/.nostr_keys_backup, 
                  and make a new one
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
unset skipwallet
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
export skipwallet="true"
break
;;
2)
rm -rf $dp/.nostr_keys
break
;;
3)
mv $dp/.nostr_keys $dp/.nostr_keys_backup
break
;;
*)
invalid
;;
esac
done
fi
}