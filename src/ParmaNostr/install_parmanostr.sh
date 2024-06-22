function install_parmannostr {

#intro - what parmanostr does. Recommend own relay.
#dependencies
installed_confif_add "parmanostr-start"
#make wallet
#make gpg keys
#make a backup of the wallet and encrypt with gpg


installed_config_add "parmanostr-end"
success "ParmanNostr has been installed"

}

function make_nostr_wallet {

while true ; do
set_terminal ; echo -e "
########################################################################################

    You have options:

$cyan        1)$orange   Make a Nostr Wallet (key pair) with Parmanode using NIP-6

$cyan        2)$orange   Import your own Nostr Wallet...
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
break
;;
2)
import_nostr_wallet
;;
*)
invalid
;;
esac
done

}