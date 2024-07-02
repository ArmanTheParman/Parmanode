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

if [[ $debug == 1 ]] ; then
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

mkdir $dp/.nostr_keys/ >/dev/null 2>&1
echo "$word1$word2$word3$word4$word5$word6$word7$word8$word9$word10$word11$word12" > $dp/.nostr_keys/random_binary.txt  2>/dev/null
make_checksum || { announce "an error occurred calculating the checksum" ; return 1 ; }

    word1dec=$(echo "ibase=2; $word1" | bc)
    word2dec=$(echo "ibase=2; $word2" | bc)
    word3dec=$(echo "ibase=2; $word3" | bc)
    word4dec=$(echo "ibase=2; $word4" | bc)
    word5dec=$(echo "ibase=2; $word5" | bc)
    word6dec=$(echo "ibase=2; $word6" | bc)
    word7dec=$(echo "ibase=2; $word7" | bc)
    word8dec=$(echo "ibase=2; $word8" | bc)
    word9dec=$(echo "ibase=2; $word9" | bc)
    word10dec=$(echo "ibase=2; $word10" | bc)
    word11dec=$(echo "ibase=2; $word11" | bc)
    word12dec=$(echo "ibase=2; $(cat $dp/.nostr_keys/full_binary.txt | cut -c 122-132)" | bc)
debug 1
    word1text=$(head -n$(($word1dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word2text=$(head -n$(($word2dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word3text=$(head -n$(($word3dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word4text=$(head -n$(($word4dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word5text=$(head -n$(($word5dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word6text=$(head -n$(($word6dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word7text=$(head -n$(($word7dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word8text=$(head -n$(($word8dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word9text=$(head -n$(($word9dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word10text=$(head -n$(($word10dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word11text=$(head -n$(($word11dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
    word12text=$(head -n$(($word12dec+1)) $pn/src/ParmaWallet/docs/english.txt | tail -n1)
echo "$word1text $word2text $word3text $word4text $word5text $word6text $word7text $word8text $word9text $word10text $word11text $word12text" | tee $dp/.nostr_keys/mnemonic.txt >/dev/null 2>&1

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

function make_checksum {

python3 <<END
import sys, os
import unicodedata, hashlib, binascii, hmac

random_binary_path = "$dp/.nostr_keys/random_binary.txt"
full_binary_path = "$dp/.nostr_keys/full_binary.txt"

with open (random_binary_path, 'r') as file:
   random_bin = file.read().strip()

assert len(random_bin) == 128
bin_key_int = int(random_bin, 2)                                 #interpret as binary and convert to integer
bin_key_bytes = bin_key_int.to_bytes(16, 'big')                  #convert inetger to bytes
hash_of_bin_key = hashlib.sha256(bin_key_bytes).hexdigest()[0:1] #hash the bytes and get first hex character
hash_int = int(hash_of_bin_key, 16)                              #convert first hex string character to integer
hash_binary = bin(hash_int)[2:].zfill(4)                         #convert hex integer to binary string, cut out prefix, then fill to 4 characters.

full_bin_key = random_bin + hash_binary

with open (full_binary_path, 'w') as file:
    file.write(full_bin_key + '\n')
END
}