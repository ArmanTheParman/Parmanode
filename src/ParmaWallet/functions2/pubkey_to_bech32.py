import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 
import base58
from ecdsa import SECP256k1
#
import os
import bech32
import binascii
from bech32 import *
from bip_utils import *
from bitcoinlib import *

def convertbits_custom(data, frombits, tobits, pad=True):
    """General power-of-2 base conversion."""
    acc = 0
    bits = 0
    ret = []
    maxv = (1 << tobits) - 1
    max_acc = (1 << (frombits + tobits - 1)) - 1
    for value in data:
        if value < 0 or (value >> frombits):
            return None
        acc = ((acc << frombits) | value) & max_acc
        bits += frombits
        while bits >= tobits:
            bits -= tobits
            ret.append((acc >> bits) & maxv)
    if pad and bits:
        ret.append((acc << (tobits - bits)) & maxv)
    return ret

def pubkey_to_bech32(pubkey, version=0, hrp='bc'):
    # Compute the SHA-256 hash of the public key
    sha_pubkey = sha256(pubkey).digest()
    
    # Compute the RIPEMD-160 hash of the SHA-256 hash
    ripemd_pubkey = hash160(sha_pubkey)
    
    # Convert to Bech32 address
    # 0 is the witness version for "bc1" addresses (for version 0 SegWit addresses)
    five_bit_r = bech32.convertbits(ripemd_pubkey, 8, 5)
    return bech32.Bech32Encoder.Encode(hrp, [version] + five_bit_r)

    
