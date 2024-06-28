function confirm_mnemonic {

#print(sys.path)  

python3 <<END
import sys, copy, os
sys.path.append("$pn/src/ParmaWallet")
from classes import *
from functions import *
from variables import *
from nostr import *
import unicodedata, hashlib, binascii, hmac

wordlist_path = "$pn/src/ParmaWallet/docs/english.txt"
mnemonic_path = "$dp/.nostr_keys/mnemonic.txt"

with open (mnemonic_path, 'r') as file:
   content = file.read()
   words = content.split()

with open (wordlist_path, 'r') as file:
   enumerated_lines = [(format(line_number, '011b'), line.strip()) for line_number, line in enumerate(file)]

#print(enumerated_lines)

bin_key = ""

for i in range(12):
    for bin_num, word in enumerated_lines:
       if words[i] == word:
           bin_key = bin_key + str(bin_num)

bin_key_int = int(bin_key[0:128], 2)                             #extract 128 bits, interpret as binary and convert to integer
bin_key_bytes = bin_key_int.to_bytes(16, 'big')                  #convert inetger to bytes
hash_of_bin_key = hashlib.sha256(bin_key_bytes).hexdigest()[0:1] #hash the bytes and get first hex character
hash_int = int(hash_of_bin_key, 16)                              #convert first hex string character to integer
hash_binary = bin(hash_int)[2:].zfill(4)                         #convert hex integer to binary string, cut out prefix, then fill to 4 characters.

final_word_random_bin = bin_key[121:128]
final_word_full_bin_test = final_word_random_bin + hash_binary

for bin_num, word in enumerated_lines:
    if final_word_full_bin_test == bin_num:
        if word == words[11]:
            exit(0)
        else:
            exit(1)

exit(2)            
END
}