import base58, hmac, hashlib, ecdsa, os
from ecdsa.curves import SECP256k1
from ecdsa.ecdsa import int_to_string

def extract_chain_code(xprv):
    # Decode the xprv from Base58Check encoding
    decoded_xprv = base58.b58decode_check(xprv)

    # Extract the chain code (bytes 13 to 45)
    chain_code = decoded_xprv[13:45]
    return chain_code

def int_to_bytes(i):
    # Ensure the integer fits into 32 bytes (256 bits)
    # by reducing it modulo the order of the secp256k1 curve
    i = i % SECP256k1.order
    return i.to_bytes(32, byteorder='big', signed=False)

def hmac_sha512(key, data):
    return hmac.new(key, data, hashlib.sha512).digest()

def derive_hardened_child_key(parent_priv_key, parent_chain_code, index):
    assert index >= 2**31  # Hardened keys have index >= 2**31

    # Prepend 0x00 to the parent private key
    data = b'\x00' + int_to_bytes(parent_priv_key) + index.to_bytes(4, byteorder='big')

    # HMAC-SHA512 with parent chain code as key, and data as message
    I = hmac_sha512(parent_chain_code, data)

    # Split I into two 32-byte sequences, IL and IR
    IL, IR = I[:32], I[32:]

    # Convert IL to integer and add it to the parent private key
    child_priv_key = (int.from_bytes(IL, 'big') + parent_priv_key) % SECP256k1.order

    return child_priv_key, IR

########################################################################################################################

def base58check_encode2(payload):
    checksum = hashlib.sha256(hashlib.sha256(payload).digest()).digest()[:4]
    return base58.b58encode(payload + checksum)

def serialize_extended_key(version, depth, parent_fingerprint, child_number, chain_code, private_key):
    extended_key = (version + depth + parent_fingerprint + child_number + chain_code + b'\x00' + private_key)
    return base58check_encode2(extended_key)

########################################################################################################################

def private_to_public(private_key):
    sk = ecdsa.SigningKey.from_string(private_key, curve=ecdsa.SECP256k1)
    vk = sk.get_verifying_key()
    return b'\x04' + vk.to_string()  # 0x04 prefix for uncompressed public key

def public_to_address(public_key, version_byte=b'\x00'):
    # Perform SHA-256 hashing on the public key
    sha256 = hashlib.sha256(public_key).digest()
    
    # Perform RIPEMD-160 hashing on the result
    ripemd160 = hashlib.new('ripemd160', sha256).digest()
    
    # Add version byte (0x00 for Main Network)
    payload = version_byte + ripemd160
    
    # Calculate checksum
    checksum = hashlib.sha256(hashlib.sha256(payload).digest()).digest()[:4]
    
    # Perform Base58Check encoding
    return base58.b58encode(payload + checksum)

    
########################################################################################################################

def extract_private_key_from_xprv(xprv):
    # Decode the xprv from Base58Check encoding
    decoded_xprv = base58.b58decode_check(xprv)

    # Extract the raw private key (skip the first 46 bytes: version (4) + depth (1) + parent fingerprint (4) + child number (4) + chain code (32) + padding (1))
    raw_private_key = decoded_xprv[46:]
    return raw_private_key