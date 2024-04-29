from classes import *
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 

import os
from bech32 import bech32_encode, convertbits
from bip_utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes


########################################################################################
########################################################################################

charlist = ( b'a', b'b', b'c', b'c', b'd', b'e', b'f', b'g', b'h', b'i', b'j', b'k', b'l', b'm', b'n', b'o', b'p', b'q', b'r', b's', b't', b'u', b'v', b'w', b'x', b'y', b'z')
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
passphrase = b''
a = BIP32_master_node(mnemonic, passphrase)
b = child_key(a, depth=1, account=84, hardened=True, serialize=True) #purpose
c = child_key(b, depth=1, account=0, hardened=True, serialize=True) #coin
d = child_key(c, depth=1, account=0, hardened=True, serialize=True) #account
e = child_key(d, depth=1, account=0, hardened=False, serialize=True) #int/ext
f = child_key(e, depth=1, account=0, hardened=False, serialize=True) #address

public_key = f.public_key
print("xxxxxxxxx")
print(public_key)
# Convert public key to witness program format
witness_program = convertbits(public_key[1:], 8, 5)

print ("pubkey :" , public_key )
# Generate a SegWit address using bech32 encoding
address = bech32_encode('bc', [0] + witness_program)
print("Address: " + address)