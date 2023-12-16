from classes import *
from functions import *
from variables import *
import hmac, hashlib, ecdsa, os, unicodedata, binascii
#from ecdsa.curves import SECP256k1
# from ecdsa.ecdsa import int_to_string

a = BIP39seed()
# print(a)
a.make_child_private_key()
a.make_d2_child()
a.make_d3_child()