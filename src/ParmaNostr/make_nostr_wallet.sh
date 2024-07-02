function make_nostr_wallet {

while true ; do
set_terminal ; echo -e "
########################################################################################

    You have options:
$cyan        
        1)$orange Make a Nostr Wallet (key pair) with Parmanode. This will help 
           you set up keys from a BIP39 seed phrase, according to the NIP-6 
           protocol. That way, you have an easy way to record down and recover
           your Nostr keys.
$cyan
        2)$orange Import your own Nostr keys
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

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Choice of BIP-39 words
$orange
        1) BYO words, eg from Ian Coleman'w BIP-39 webtool

        2) Dice rolls or coin toss (Parmanode will help you)...
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
nostr_keys_byo
break
;;

2)
nostr_keys_with_dice
break
;;

*)
invalid
;;
esac
done

make_npub #takes pub.txt and makes npub.txt

}
