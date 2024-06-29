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
#proforma

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
byo="true"
break
;;

2)
dice="true"
break
;;

*)
invalid
;;
esac
done

if [[ $byo == "true" ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Get a 12 word seed from somewhere, eg Ian Coleman's BIP39 Webtool. Then type it
    in here, separated by spaces.
    $pink
    Please do not use the seed phrase of a real Bitcoin Wallet! That's bloody
    dangerous. $orange

########################################################################################
"
choose xpmq ; read mnemonic ; set_terminal
case $mnemonic in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)

if ! echo "$mnemonic" | wc -w | grep 12 ; then
set_terminal ; announce "Please enter exactly 12 words."
continue
fi

mkdir -p $dp/.nostr_keys
echo "$mnemonic" | tee $dp/.nostr_keys/mnemonic.txt

#Python code to confirm checksum is valid
confirm_mnemonic ; function_exit="$?"

if [[ $function_exit == 1 ]] ; then
    rm $dp/.nostr_keys/mnemonic.txt >/dev/null 2>&1
    announce "The checksum seems to be invalid."
    continue
elif [[ $function_exit == 0 ]] ; then
    rm $dp/.nostr_keys/mnemonic.txt >/dev/null 2>&1
    announce "Please note, your mnemonic, nsec, and npub are kept unencrypted in the 
    hidden directory: $dp/.nostr_keys/

    Parmanode needs access to this directory to sign messages for you. Things will 
    stop working if you delete or move it."
    return 0
else
    rm $dp/.nostr_keys/mnemonic.txt >/dev/null 2>&1
    announce "Unexpected error. Please report to Parman."
    continue
fi
;;
esac
done
fi


if [[ $dice == "true" ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Using dice or coins, you can get 128 bits of randomness...
$orange
    For DICE:
        
        There are various ways to get binary output from dice even if they have six
        sides. Eg, Consider even numbers as 0, and odd numbers as 1. Or you could 
        consider numbers 1,2,3 as result=0, and 4,5,6 as result=1. You can roll one 
        at a time or several at a time, as long as you read them according to strict 
        rules. Eg, if you had multiple dice, read them left to right every time, and 
        if there are any overlapping vertically, ready above then below; as long as
        you are consistent, it'll be perfectly random.

    For Coins:

        A bit easier conceptually. Use heads as result=0 and tails as result=1 
        (or reverse). 
$orange
########################################################################################
"
choose epmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

*)
break
;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in your$cyan first 11$orange results, then hit$cyan <enter>$orange.

    eg:

        0101110010

$green
    This will become word 1
$orange
########################################################################################    
"
choose xpmq ; read word1 ; set_terminal
case $word1 in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
if ! echo $word1 | grep -E '^[01]{11}$' ; then
announce "Please try again for word 1 (hit$cyan <enter>$orange first)
    You need exactly$cyan eleven$orange one's and zero's."
continue
fi
break
;;
esac
done

for ((n = 2; n < 12; n++)); do
while true ; do
unset thisword
set_terminal ; echo -e "
########################################################################################

    Please type in$cyan next 11$orange binary results, then hit$cyan <enter>$orange.
$green

    This will become word $n
$orange
########################################################################################    
"
choose xpmq ; read "word$n" ; set_terminal
eval thisword="\$word$n"
case $thisword in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
if ! echo "$thisword" | grep -E '^[01]{11}$' ; then
announce "Please try again for word $n (hit$cyan <enter>$orange first)
    You need exactly$cyan eleven$orange one's and zero's."
continue
fi
break
;;
esac
done
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    Please type in last$cyan 7 binary$orange results (not 11), then hit$cyan <enter>$orange.

    This will make up part of the final word (together with the checksum, to be
    calculated soon)

########################################################################################    
"
choose xpmq ; read "word12" ; set_terminal
case $word12 in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
if ! echo $word12 | grep -E '^[01]{7}$' ; then
announce "Please try again for word 12 (hit$cyan <enter>$orange first)
    You need exactly$cyan seven$orange one's and zero's."
continue
fi
break
;;
esac
done


set_terminal ; echo -e "
########################################################################################

    The binary in full (without added checksum) is:

    $word1
    $word2
    $word3
    $word4
    $word5
    $word6
    $word7
    $word8
    $word9
    $word10
    $word11
    $word12

########################################################################################
"
enter_continue
fi
}
