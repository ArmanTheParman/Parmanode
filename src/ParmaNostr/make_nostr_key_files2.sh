function make_nostr_key_files2 {

#For use when a valid mnemonic alrady exists

python3 <<END
import sys, copy, os
sys.path.append("$pn/src/ParmaWallet")
from classes import *
from functions import *
from functions2 import *
from variables import *
from nostr import *
import unicodedata, hashlib, binascii, hmac

wordlist_path = "$pn/src/ParmaWallet/docs/english.txt"
mnemonic_path = "$dp/.nostr_keys/mnemonic.txt"
nostr_nsec = "$dp/.nostr_keys/nsec.txt"
nostr_npub = "$dp/.nostr_keys/npub.txt"
nostr_nsec_bytes = "$dp/.nostr_keys/nsec_bytes.txt"

with open (mnemonic_path, 'r') as file:
   content = file.read().strip()
   words = content.split()

with open (wordlist_path, 'r') as file:
   enumerated_lines = [(format(line_number, '011b'), line.strip()) for line_number, line in enumerate(file)]

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

while True:
    for bin_num, word in enumerated_lines:
        if final_word_full_bin_test == bin_num:
            if word == words[11]:
                flag=1
                break 
            else:
                exit(1)
    if flag == 1:
        break
    exit(2)            

the_keypair=derive_keys(depth="address", purpose=44, coin=1237, mnemonic=content) #NIP6

with open(nostr_nsec_bytes, 'w') as file:
    the_secret_bytes=the_keypair.private_key.secret_bytes
    file.write(str(the_secret_bytes) + '\n')

with open(nostr_nsec, 'w') as file:
    file.write(make_nsec(the_secret_bytes) + '\n')

with open(nostr_npub, 'w') as file:
    pubkey_schnorr=the_keypair.public_key[1:].hex()
    file.write(pubkey_schnorr + '\n')

END
}