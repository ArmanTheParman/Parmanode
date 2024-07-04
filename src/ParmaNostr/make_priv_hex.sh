function make_priv_hex {
debug "in make_priv hex"

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
nostr_nsec_bytes = "$dp/.nostr_keys/nsec_bytes.txt"
random_binary_path = "$dp/.nostr_keys/random_binary.txt"
nostr_priv_hex = "$dp/.nostr_keys/priv_hex.txt"

with open (nostr_nsec, 'r') as file:
    nsec_str = file.read().strip()

nsec_bytes = nsec_to_bytes(nsec_str)

priv_hex = nsec_bytes.hex()

with open (nostr_priv_hex, 'w') as file:
    file.write((priv_hex) + '\n')
EOF

debug "after make_priv_hex, before exit"
}