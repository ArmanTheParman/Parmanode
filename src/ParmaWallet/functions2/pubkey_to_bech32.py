import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 
import base58
from ecdsa import SECP256k1

import os
from bech32 import bech32_encode, convertbits
from bip_utils import Bip39MnemonicGenerator, Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes


def pubkey_to_bech32(pubkey, version=0, hrp='bc'):
    # Compute the SHA-256 hash of the public key
    sha_pubkey = sha256(pubkey).digest()
    
    # Compute the RIPEMD-160 hash of the SHA-256 hash
    ripemd_pubkey = hash160(sha_pubkey)
    
    # Convert to Bech32 address
    # 0 is the witness version for "bc1" addresses (for version 0 SegWit addresses)
    five_bit_r = bech32.convertbits(ripemd_pubkey, 8, 5)
    return bech32.bech32_encode(hrp, [version] + five_bit_r)

    
