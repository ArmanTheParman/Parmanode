function make_priv_hex_bytes {
python3 <<EOF
import sys, copy, os
sys.path.append("$pn/src/ParmaWallet")
from classes import *
from functions import *
from functions2 import *
from variables import *
from nostr import *
import unicodedata, hashlib, binascii, hmac

nostr_nsec = "$dp/.nostr_keys/nsec.txt"
nostr_pub = "$dp/.nostr_keys/pub.txt"
nostr_nsec_bytes = "$dp/.nostr_keys/nsec_bytes.bin"
random_binary_path = "$dp/.nostr_keys/random_binary.txt"
full_binary_path = "$dp/.nostr_keys/full_binary.txt"
nostr_priv_hex = "$dp/.nostr_keys/priv_hex.txt"

with open (nostr_priv_hex, 'r') as file:
    phex_str = file.read().strip()

phex_bytes = bytes.fromhex(phex_str)

#print(phex_bytes)
#print(len(phex_bytes))

with open (nostr_nsec_bytes, 'wb') as file:
    file.write(phex_bytes + b'\n')
EOF
}