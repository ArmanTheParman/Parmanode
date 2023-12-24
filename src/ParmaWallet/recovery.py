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
       
pubkey_target = 0x024ee3afc0eb0abb9f8bfc2b67e394a44fdc97eabe08f0e3d88e1dd9c76371949c
derivation_target = "m/84'/0'/0'/0/1"
target_mnemonic = input("please type in seed seperated with spaces: ")
passphrase_target = "a"

a = BIP39seed()