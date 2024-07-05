function make_nostr_key_files2 {
debug "in make nostr key files 2 - check files"
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
nostr_pub = "$dp/.nostr_keys/pub.txt"
nostr_nsec_bytes = "$dp/.nostr_keys/nsec_bytes.bin"
random_binary_path = "$dp/.nostr_keys/random_binary.txt"
full_binary_path = "$dp/.nostr_keys/full_binary.txt"

with open (wordlist_path, 'r') as file:
        # List will be numbered using binary, starting from zero
        bip39list_lines = [(format(line_number, '011b'), line.strip()) for line_number, line in enumerate(file)]

# Code splits here, path A and path B. If function being called to check a mnemonic (A) vs inputing a full binary key (B)...

if os.path.exists(mnemonic_path):      #path A
    codepath = "A"
    with open (mnemonic_path, 'r') as file:
        content = file.read().strip()
        words = content.split()

    bin_key = ""

    for i in range(12):
        for bin_num, word in bip39list_lines:
           if words[i] == word:
               bin_key = bin_key + str(bin_num)

    full_bin_key = bin_key
    
sys.exit(3)
END
}