# Basic code, the beginnings of a Bitcoin recovery tool and maybe a full blown wallet one day.
# Code currently no accessible from Parmonde menus.

import os, binascii, hashlib, unicodedata, hmac, ecdsa, struct, base58
from ecdsa.curves import SECP256k1
from ecdsa.ecdsa import int_to_string, string_to_int

phrase = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about" 

normalized_mnemonic = unicodedata.normalize("NFKD", phrase)
password = "hello"
normalized_passphrase = unicodedata.normalize("NFKD", password)
passphrase = "mnemonic" + normalized_passphrase
mnemonic = normalized_mnemonic.encode("utf-8")
passphrase = passphrase.encode("utf-8")

bin_seed = hashlib.pbkdf2_hmac("sha512", mnemonic, passphrase, 2048)
print (bin_seed)
print(binascii.hexlify(bin_seed[:64]))
hex_seed = binascii.hexlify(bin_seed[:64])

#hex to binary for the seed
seed = binascii.unhexlify(hex_seed)
#make I
I = hmac.new(b"Bitcoin seed", seed, hashlib.sha512).digest()
#left and right parts
Il, Ir = I[:32], I[32:]
#serialisation

xpriv = binascii.unhexlify("0488ADE4") # codes for "xprv" string
xpub = binascii.unhexlify("0488B21E") # codes for "xpub" string
depth = b"\x00" #the derivation depth is coded using 1 byte
fp = b"\0\0\0\0"     # 4 bytes for the fingerprint of the parent's key, but zero if this is the master key
index = 0
child = struct.pack(">L", index)
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

#hex to binary for the seed
seed = binascii.unhexlify(hex_seed)
#make I
I = hmac.new(b"Bitcoin seed", seed, hashlib.sha512).digest()
#left and right parts
Il, Ir = I[:32], I[32:]
#serialisation

xpriv = binascii.unhexlify("0488ADE4") # codes for "xprv" string
xpub = binascii.unhexlify("0488B21E") # codes for "xpub" string
depth = b"\x00" #the derivation depth is coded using 1 byte
fp = b"\0\0\0\0"     # 4 bytes for the fingerprint of the parent's key, but zero if this is the master key
index = 0
child = struct.pack(">L", index)
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
