import os
from classes import *
from classes import BIP32_master_node 
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac

def derive_keys(depth: str='address', mnemonic: str=None, passphrase: str='', purpose=44, coin=0, account=0, change=0, address=0):

    a = BIP32_master_node(mnemonic, passphrase)
    b = Child_key(a, depth=1, index=purpose, hardened=True, serialize=False)
    c = Child_key(b, depth=1, index=coin, hardened=True, serialize=False)
    d = Child_key(c, depth=1, index=account, hardened=True, serialize=False)
    e = Child_key(d, depth=1, index=change, hardened=False, serialize=False) 
    f = Child_key(e, depth=1, index=address, hardened=False, serialize=True) 

    if depth == 'm':
        return a
    if depth == 'purpose':
        return b
    if depth == 'coin':
        return c
    if depth == 'account':
        return d
    if depth == 'change':
        return e
    if depth == 'address':
        return f