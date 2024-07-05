function make_nostr_wallet {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                              P A R M A N O S T R 
$orange
########################################################################################

$orange      
    ParmaNostr is just getting started - I have big dreams for it. 
    For now, it's just a tool to build (or import) your own Nostr key pair. 

    $cyan        
    You have options:

$green        1)$orange BYO words, eg from Ian Coleman's BIP-39 webtool

$green        2)$orange Dice rolls or coin toss (Parmanode will help you) to make your own words

$green        3)$orange Import your own Nostr keys (eg nsec or private hex key, not seed words)




    ParmaNostr will store the info on the computer at:

    ${bright_blue}$dp/.nostr_keys/$orange
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
unset bip39
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
debug "in 1"
nostr_keys_byo
break
;;
2)
nostr_keys_with_dice || return 1
break
;;
3)
import_nostr_keys || return 1
break
;;
*)
invalid
;;
esac
done

make_npub #takes pub.txt and makes npub.txt

if [[ ! -e $dp/.nostr_keys/priv_hex.txt ]] ; then
make_priv_hex || return 1
fi

rm $dp/.nostr_keys/random_binary.txt >/dev/null 2>&1
return 0 #needed in case rm command above fails.
}
