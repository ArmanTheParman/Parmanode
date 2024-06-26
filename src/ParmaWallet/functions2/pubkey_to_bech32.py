import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from classes import PrivateKey
from variables import * 
from classes import N
import base58
from ecdsa import SECP256k1

import os
from bech32 import bech32_encode, convertbits
from bip_utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes #use bip_utils even though package is called bip-utils
import bech32
import binascii
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

def pubkey_to_bech32_custom(pubkey, version=0, hrp='bc'):
    # Convert to Bech32 address
    pubkey_hashed=hash160(pubkey)
    # 0 is the witness version for "bc1" addresses (for version 0 SegWit addresses)
    five_bit_r = convertbits_custom(pubkey_hashed, 8, 5)
    return bech32.bech32_encode(hrp, [version] + five_bit_r)

########################################################################################

def pubkey_to_bech32_old (pubkey, version=0, hrp='bc'):
    # Compute the SHA-256 hash of the public key
    sha_pubkey = sha256(pubkey).digest()
    
    # Compute the RIPEMD-160 hash of the SHA-256 hash
    ripemd_pubkey = hash160(sha_pubkey)
    
    # Convert to Bech32 address
    # 0 is the witness version for "bc1" addresses (for version 0 SegWit addresses)
    five_bit_r = convertbits_custom(ripemd_pubkey, 8, 5)
    return bech32.bech32_encode(hrp, [version] + five_bit_r)

#takes a pubkey object
def pubkey_to_bech32_original(the_pubkey):
    
    # hashx2 the public key (bytes)
    public_key_hash=hash160(the_pubkey) 

    # Convert public key to witness program format
    witness_program = convertbits(public_key_hash, 8, 5)

    # Generate a SegWit address using bech32 encoding
    address = bech32_encode('bc', [0] + witness_program)
    print("Address: " + address)
   

def make_nsec(secret_bytes):   
    # Convert bytes to 5-bit words
    private_key_5bit = convertbits_custom(secret_bytes, 8, 5)

    # Encode using Bech32 with "nsec" prefix
    return bech32.bech32_encode("nsec", private_key_5bit) 

def nsec_to_bytes(nsec):
    # Decode the Bech32 string to get the 5-bit words
    hrp, data = bech32.bech32_decode(nsec)
    
    if hrp != 'nsec':
        raise ValueError("Invalid nsec string")

    # Convert 5-bit words back to 8-bit bytes
    decoded_bytes = convertbits_custom(data, 5, 8, False)
    
    # Return the byte array
    return bytes(decoded_bytes)

def make_npub(pubkey: str = None):

    # Convert the hexadecimal key to bytes
    pub_key_bytes = bytes.fromhex(pubkey)

    # Convert 8-bit bytes to 5-bit array
    pub_key_5bit = convertbits_custom(pub_key_bytes, 8, 5, pad=True)

    # Bech32 encode with "npub" prefix
    npub_key = bech32_encode('npub', pub_key_5bit)

    return (npub_key)