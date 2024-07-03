function make_nsec_bytes {
python3 <<EOF
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
nostr_nsec_bytes = "$dp/.nostr_keys/nsec_bytes.txt"
random_binary_path = "$dp/.nostr_keys/random_binary.txt"
full_binary_path = "$dp/.nostr_keys/full_binary.txt"

with open (nostr_nsec, 'r') as file:
    nsec_str = file.read().strip()

nsec_bytes = nsec_to_bytes(nsec_str)

with open (nostr_nsec_bytes, 'wb') as file:
    file.write(nsec_bytes + b'\n')
EOF
}