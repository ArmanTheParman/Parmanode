function nostr_keys_with_dice {
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

        01011100101

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

mkdir $dp/.nostr_keys/ >/dev/null 2>&1
echo "$word1$word2$word3$word4$word5$word6$word7$word8$word9$word10$word11$word12" > $dp/.nostr_keys/random_binary.txt  2>/dev/null

make_nostr_key_files

set_terminal ; echo -e "
########################################################################################
$green                                  
                                  S U C C E S S  ! !
$orange
    ParmaNostr has been installed. Your 12 word Nostr mnemonic seed phrase is:
$cyan
    $(cut -d ' ' -f 1-6 $dp/.nostr_keys/mnemonic.txt)
    $(cut -d ' ' -f 7-12 $dp/.nostr_keys/mnemonic.txt)

$orange
########################################################################################
"
success="done"
enter_continue ; set_terminal ; return 0
}
