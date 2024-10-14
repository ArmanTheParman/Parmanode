function install_parmanostr {
#make wallet
if [[ $debug != 1 ]] ; then install_parmawallet_dependencies ; fi

check_nostr_wallet_exists #get skipwallet value

if [[ $skipwallet != "true" ]] ; then
make_nostr_wallet || return 1
debug "after make_nostr_wallet"
installed_config_add "parmanostr-start"
fi
unset skipwallet

#make gpg keys
#make a backup of the wallet and encrypt with gpg


installed_config_add "parmanostr-end"
debug "before removal of random_binary.txt"
rm $dp/.nostr_keys/random_binary.txt >/dev/null 2>&1

debug "before make_sourcable_keys_file"

make_sourcable_keys_file

if [[ $success != "done" ]] ; then
success "ParmaNostr has been installed"
fi
return 0
}

