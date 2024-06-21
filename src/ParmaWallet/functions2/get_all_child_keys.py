import os
from classes import *
from classes import BIP32_master_node 
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac

def get_all_child_keys(depth: str='f', mnemonic: str=None, passphrase: str=''):

    a = BIP32_master_node(mnemonic, passphrase)
    b = Child_key(a, depth=1, account=84, hardened=True, serialize=False) #purpose
    c = Child_key(b, depth=1, account=0, hardened=True, serialize=False) #coin
    d = Child_key(c, depth=1, account=0, hardened=True, serialize=False) #account
    e = Child_key(d, depth=1, account=0, hardened=False, serialize=False) #int/ext
    f = Child_key(e, depth=1, account=0, hardened=False, serialize=True) #address

    if depth == 'a':
        return a
    if depth == 'b':
        return b
    if depth == 'c':
        return c
    if depth == 'd':
        return d
    if depth == 'e':
        return e
    if depth == 'f':
        return f