import os
from classes import *
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac

########################################################################################
#iteration function
########################################################################################






########################################################################################
########################################################################################

mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon " + w22 + w23 + wcheck
passphrase = b''
a = BIP32_master_node(mnemonic, passphrase)
b = child_key(a, depth=1, account=84, hardened=True, serialize=False) #purpose
c = child_key(b, depth=1, account=0, hardened=True, serialize=False) #coin
d = child_key(c, depth=1, account=0, hardened=True, serialize=False) #account
e = child_key(d, depth=1, account=0, hardened=False, serialize=False) #int/ext
f = child_key(e, depth=1, account=0, hardened=False, serialize=True) #address


make_segwit_address(f.serialize())