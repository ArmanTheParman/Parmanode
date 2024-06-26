import hashlib
from functions.PW_Base58 import *
from functions.PW_functions import *
from classes.Script import *
import os
from classes import *
from functions import *
from variables import * 
import bech32
#from bech32 import bech32_encode, convertbits
from bip-utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes

#ripemd160
from Crypto.Hash import SHA256, RIPEMD160


#usage - pass a byte object, encode the string to do so
#eg "hello".encode('utf-8')

def hash160(so):
#sha256 followed by ripemd160

# various versions of RIPEMD works on different systems. Need to pick one.

#1    return hashlib.new('ripemd160', hashlib.sha256(so).digest()).digest()   #maybe slower, w

        # from cryptography.hazmat.primitives import hashes
        # from cryptography.hazmat.backends import default_backend
        # from cryptography.hazmat.primitives import hashes
#2    return hash_ripemd160(hashlib.sha256(so).digest()).digest()           #depends on openssl

#3
    return RIPEMD160.new(hashlib.sha256(so).digest()).digest()   #maybe slowerest?

def read_varint(s):
    '''read_varint reads a variable integer from a stream'''
    i = s.read(1)[0] # byte object returned with read, and value extraced with [0]
    if i == 0xfd:
        return little_endian_to_int(s.read(2))
    elif i == 0xfe:
        return little_endian_to_int(s.read(4))
    elif i == 0xff:
        return little_endian_to_int(s.read(8))
    else:
        #anything else is an integer
        return i

def encode_varint(i):
    '''encodes an integer as a varint'''
    if i < 0xfd:
        return bytes([i])
    elif i <0x10000:
        return b'\xfd' + int_to_little_endian(i, 2)
    elif i <0x100000000:
        return b'\xfe' + int_to_little_endian(i, 4)
    elif i <0x10000000000000000:
        return b'\xff' + int_to_little_endian(i, 8)
    else: 
        raise ValueError('integer too large: {}'.format(i))

def int_to_little_endian(variable, len):
    if not isinstance(variable, int):
        raise TypeError("variable needs to be an integer")
    return variable.to_bytes(len, 'little')    

def little_endian_to_int(byteobject):
    result=int.from_bytes(byteobject, "little")
    return result

def hash256(input):
    if not isinstance(input, bytes):
        raise TypeError
    return hashlib.sha256(input).digest()

def p2pkh_script(h160):
    '''Takes a hash160 and returns the p2pkh ScriptPubKey'''
    return Script([0x76, 0xa9, h160, 0x88, 0xac])
    
