function make_pubkey {

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
nostr_nsec_bytes = "$dp/.nostr_keys/nsec_bytes.bin"
random_binary_path = "$dp/.nostr_keys/random_binary.txt"
full_binary_path = "$dp/.nostr_keys/full_binary.txt"

with open (nostr_nsec_bytes, 'rb') as file:
    nsec_bytes = file.read().strip()
    
pubkey = hex(PrivateKey(nsec_bytes).point.x.num)[2:]
with open (nostr_pub, 'w') as file:
    file.write(pubkey + '\n')
EOF

}