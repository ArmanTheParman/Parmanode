#will be redundant soon
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