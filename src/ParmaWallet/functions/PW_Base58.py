import hashlib
from functions.PW_functions import *

BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def encode_base58(s):

    if not isinstance(s, bytes):
        raise TypeError("argument for encode_base58 needs to be a byte object")

    count=0
    for c in s:       #count number of leading zeros in s
        if c==0:
            count+=1
        else:
            break
    
    num = int.from_bytes(s, 'big')
    prefix = '1' * count            # no zeros in base 58, 1 is used as zero
    result = ''
    
    while num > 0:
        num, mod = divmod(num, 58)              # do num/58, return quotient and remainder as a tuple
        result = BASE58_ALPHABET[mod] + result  # '+' builds a string
    
    return prefix + result
    
def base58check_encode(b):
    checksum = hashlib.sha256(hashlib.sha256(b).digest()).digest()[:4]
    # print(b + checksum)
    return encode_base58(b + checksum)

def decode_base58(s):
    num = 0 
    for c in s:
        num *= 58
        num += BASE58_ALPHABET.index(c)
    combined = num.to_bytes(25, byteorder='big')
    checksum = combined[-4:]
    if hash256(combined[:-4])[:4] != checksum:
        raise ValueError('bad address: {} {}'.format(checksum, 
            hash256(combined[:-4])[:4]
            )
       )
    return combined[1:-4]

    