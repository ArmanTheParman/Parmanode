from classes import *
from functions import *
from variables import *
import hmac, hashlib, ecdsa, os, unicodedata, binascii
import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 
from classes import N
import base58
from ecdsa import SECP256k1
       
a = BIP32_master_node()
b = child_key(a, depth=1, account=49, hardened=True, serialize=True) #purpose
c = child_key(b, depth=1, account=0, hardened=True, serialize=True) #coin
d = child_key(c, depth=1, account=0, hardened=True, serialize=True) #account
e = child_key(d, depth=1, account=0, hardened=False, serialize=True) #int/ext
f = child_key(e, depth=1, account=0, hardened=False, serialize=True) #address
a.serialize()
b.serialize()
c.serialize()
d.serialize()
e.serialize()
f.serialize()