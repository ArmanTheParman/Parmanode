function install_parmanostr {
intro_parmanostr || return 1
#make wallet
install_parmawallet_dependencies
if [[ -d $dp/.nostr_keys ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Nostr Key directory detected
$orange
               1) Use it

               2) Delete and start over

               3) Back it up to $dp/.nostr_keys_backup, 
                  and make a new one
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
unset skipwallet
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
skipwallet="true"
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

if [[ $skipwallet != "true" ]] ; then
make_nostr_wallet || return 1
installed_config_add "parmanostr-start"
fi
unset skipwallet

#make gpg keys
#make a backup of the wallet and encrypt with gpg


installed_config_add "parmanostr-end"
success "ParmaNostr has been installed"
}
