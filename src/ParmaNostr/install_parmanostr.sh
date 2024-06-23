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

$cyan        1)$orange Make a Nostr Wallet (key pair) with Parmanode. This will help 
                you set up keys from a BIP39 seed phrase, according to the NIP-6 
                protocol.

$cyan        2)$orange   Import your own Nostr keys
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

set_terminal ; echo -e "
########################################################################################

    Type in a 12 word seed (separated by spaces) you got from somewhere else, eg Ian 
    Coleman's BIP39 Webtool.
    $pink
    Please do not use the seed phrase of a real Bitcoin Wallet! That's bloody
    dangerous. $orange

########################################################################################
"
choose xpmq ; read mnemonic ; set_terminal
case $mnemonic in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
if ! echo "$mnemnoic" | wc -w | grep 12 ; then
set_terminal ; announce "Please enter exactly 12 words."
continue
fi
mkdir -p $dp/.nostr_keys
echo "$mnemonic" | tee $dp/.nostr_keys/mnemonic.txt
echo "$mnemonic" | cut -d " " -f1-11 | tee $dp/.nostr_keys/first_11.txt

#unfinished
esac
}