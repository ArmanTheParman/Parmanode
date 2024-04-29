from classes import *
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 



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

f.serialize()


########################################################################################
# Example usage:
########################################################################################
public_key = b'\x030\xd5O\xd0\xddB\nn_\x8d6$\xf5\xf3H,\xae5\x0fy\xd5\xf0u;\xf5\xbe\xef\x9c-\x91\xaf<'
bech32_address = pubkey_to_bech32(public_key)
print(bech32_address)