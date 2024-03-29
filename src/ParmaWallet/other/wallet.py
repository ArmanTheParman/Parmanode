# Basic code, the beginnings of a Bitcoin recovery tool and maybe a full blown wallet one day.
# Code currently no accessible from Parmonde menus.

import binascii, hashlib, unicodedata, hmac, ecdsa, struct, base58
from functions.PW_cryptofunctions import *
from ecdsa.curves import SECP256k1
from ecdsa.ecdsa import int_to_string
from functions.PW_signing import *
from functions.PW_Base58 import *
from classes.privatekey import *
from classes.S256 import * 
from classes.S256 import N
#from ecdsa.ecdsa import string_to_int


# user_passphase --> normalised_passphrase --> passphrase (string) --> passphrase (byte object)
# mnemonic --> normalised_mnemonic --> mnemonic (byte opbject)

#Start with a BIP39 Seed phrase
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about" 
normalized_mnemonic = unicodedata.normalize("NFKD", mnemonic)

#Add an optional passphrase
user_passphrase = "hello"
normalized_passphrase = unicodedata.normalize("NFKD", user_passphrase)

#if no passphrase, the passphrase will just be "mnemonic"
passphrase = "mnemonic" + normalized_passphrase
mnemonic = normalized_mnemonic.encode("utf-8")

#passphrase is now a byte object, printing --> b'string'
passphrase = passphrase.encode("utf-8")

#make a BIP39 seed (512 bits, 64 hex characters)
bin_seed = hashlib.pbkdf2_hmac("sha512", mnemonic, passphrase, 2048)  # makes a byte object
print ("The bin_seed: " , bin_seed)
print("The bin_seed in hex: " , binascii.hexlify(bin_seed[:64]))
hex_seed = binascii.hexlify(bin_seed[:64])

#hex to binary for the BIP39 keys
seed = binascii.unhexlify(hex_seed)   #byte object

#make I
I = hmac.new(b"Bitcoin seed", seed, hashlib.sha512).digest() #key=b"Bitcoin seed" data=seed
#left and right parts
Il, Ir = I[:32], I[32:] #Il=master secret key, Ir=master chain code. [ 32 byte object ]

if Il == 0 or ir > N:
    raise ValueError("Key is invalid. It is not possible to make a key with this seed. \n" +\
                      "This is actually incredible, keep this seed; 1 in 2 ^127 chance of finding it.")

#serialisation
# 1 byte, version prefix; 4 bytes for depth; 4 bytes for parent PUB KEY (always pub) fingerprint; 
# then 32 bytes for chaincode (yes it's on the "left"); 33 bytes for compressed pubkey, or if private
# key, then 1 zero byte and then 32 bytes private key. = TOTAL 78 bytes

xpriv = binascii.unhexlify("0488ADE4") # codes for "xprv" string (version prefix)
xpub = binascii.unhexlify("0488B21E") # codes for "xpub" string (version prefix)
depth = b"\x00" #the derivation depth is coded using 1 byte
fp = b"\0\0\0\0"     # 4 bytes for the fingerprint of the parent's key, but zero if this is the master key
                     # hash 33 byte compressed pubkey, then ripemed160 hash, then take first 4 bytes.

index = 0            # hardened keys start at 2^31, up to 2^32
child = struct.pack(">L", index)   #use to_bytes instead later.
chain = Ir
secret = Il

k_priv = ecdsa.SigningKey.from_string(secret, curve=SECP256k1)
K_priv = k_priv.get_verifying_key()

if K_priv.pubkey.point.y() & 1:
    data_pub=b'\3'+int_to_string(K_priv.pubkey.point.x())
else:
    data_pub = b'\2'+int_to_string(K_priv.pubkey.point.x())

data_priv = b"\x00" + k_priv.to_string()


raw_priv = xpriv + depth + fp + child + chain + data_priv
raw_pub= xpub + depth + fp + child + chain + data_pub

hashed_xpriv = hashlib.sha256(raw_priv).digest()
hashed_xpriv = hashlib.sha256(hashed_xpriv).digest()
hashed_xpub = hashlib.sha256(raw_pub).digest()
hashed_xpub = hashlib.sha256(hashed_xpub).digest()


raw_priv += hashed_xpriv[:4]
raw_pub += hashed_xpub[:4]

print(base58.b58encode(raw_priv))
print(base58.b58encode(raw_pub))
xprv=base58.b58encode(raw_priv)
xpub=base58.b58encode(raw_pub)

#Child Key derivation.
# hmac (key, message, sha512)
# message is the parent priv key || index
# key is the chaincode of the parent
#I = hmac.new(chaincode, message, hashlib.sha512).digest()

chain_code=extract_chain_code(xprv).hex()


##################################################################################################################################

# Example Usage
parent_priv_key_hex = xprv.hex()
parent_chain_code_hex = chain_code
index = 2**31  # Zero index for hardened keys

parent_priv_key = int(parent_priv_key_hex, 16)
parent_chain_code = bytes.fromhex(parent_chain_code_hex)

child_priv_key, child_chain_code = derive_hardened_child_key(parent_priv_key, parent_chain_code, index)

print("Child Private Key:", hex(child_priv_key))
print("Child Chain Code:", child_chain_code.hex())

########################################################################################################################

# Example components (these should be replaced with your actual values)
version = bytes.fromhex('0488ade4')  # Mainnet private key version prefix for xprv
depth = b'\x01'  # Depth: 1 for first child - depth is not the same as the number in the derivation path
parent_fingerprint = b'\x00\x00\x00\x00'  # Set to the master node value for now

child_number = (index).to_bytes(4, 'big')  # Child number in big-endian format
chain_code = child_chain_code  # Your derived child chain code in bytes
private_key = int_to_bytes(child_priv_key)  # Your derived child private key in bytes

xprv = serialize_extended_key(version, depth, parent_fingerprint, child_number, chain_code, private_key)
print("Extended Private Key (xprv):", xprv)

########################################################################################################################

child_private_key_bytes = extract_private_key_from_xprv(xprv)
# Convert private key to public key
child_public_key = private_to_public(child_private_key_bytes)

# Convert public key to Bitcoin address
#child_address = public_to_address(child_public_key)
child_address =  S256Point.parse(child_public_key).address("uncompressed" , testnet=False)
print("Child Public Key (hex):", child_public_key.hex())
print("Child Bitcoin Address:", child_address)
