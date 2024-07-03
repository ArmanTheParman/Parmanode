function make_nostr_wallet {

while true ; do
set_terminal ; echo -e "
########################################################################################

    You have options:
$cyan        

     1) ${orange}Make a Nostr Wallet (key pair) with Parmanode using seed words. 
     
        This will help you set up keys from a BIP39 seed phrase, according to the 
        NIP-6 protocol. That way, you have an easy way to record down and recover
        your Nostr keys. 
        
        You can generate your own seed phrase using coin tosses or dice (Parmanode) 
        will assist, or you can import 12 words you have ready.
$cyan

     2)$orange Import your own Nostr keys (eg nsec or private hex key, not seed words)
$orange

########################################################################################
"
choose xpmq ; read choice ; set_terminal
unset bip39
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
bip39="true"
break
;;
2)
import_nostr_wallet || return 1
break
;;
*)
invalid
;;
esac
done

if [[ $bip39 == "true" ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Choice of BIP-39 words
$orange
        1) BYO words, eg from Ian Coleman'w BIP-39 webtool, or keys from a ColdCard

        2) Dice rolls or coin toss (Parmanode will help you)...
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
nostr_keys_byo || return 1
break
;;

2)
nostr_keys_with_dice || return 1
break
;;

*)
invalid
;;
esac
done
fi

make_npub #takes pub.txt and makes npub.txt

if [[ ! -e $dp/.nostr_keys/priv_hex.txt ]] ; then
debug "if no priv hex"
make_priv_hex || return 1
fi
}
