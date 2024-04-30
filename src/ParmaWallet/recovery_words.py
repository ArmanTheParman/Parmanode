import os
from classes import *
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac

########################################################################################
#iteration function
########################################################################################

def get_all_child_keys(depth: str='f', mnemonic: str=None, passphrase: str=''):

    a = BIP32_master_node(mnemonic, passphrase)
    b = child_key(a, depth=1, account=84, hardened=True, serialize=False) #purpose
    c = child_key(b, depth=1, account=0, hardened=True, serialize=False) #coin
    d = child_key(c, depth=1, account=0, hardened=True, serialize=False) #account
    e = child_key(d, depth=1, account=0, hardened=False, serialize=False) #int/ext
    f = child_key(e, depth=1, account=0, hardened=False, serialize=True) #address

    # if depth == 'a':
    #     return a
    # if depth == 'b':
    #     return b
    # if depth == 'c':
    #     return c
    # if depth == 'd':
    #     return d
    # if depth == 'e':
    #     return e
    # if depth == 'f':
    #     return f
    
# def make_segwit_address(keypair_depth, address_index: int=0):
#     return  

# make_segwit_address(f.serialize())
target_string = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art"
get_all_child_keys('f', mnemonic=target_string )
