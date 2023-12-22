from classes import *
from functions import *
from variables import *
import hmac, hashlib, ecdsa, os, unicodedata, binascii
#from ecdsa.curves import SECP256k1
# from ecdsa.ecdsa import int_to_string

# a = BIP39seed()
# # print(a)
# a.make_child_private_key()
# a.make_d2_child()
# a.make_d3_child()

from io import BytesIO

# Assuming a dummy Script class with a basic serialize method
class Script:
    def serialize(self):
        return b'\x01'  # Dummy byte representation of a script

# Dummy function for little endian conversion
def int_to_little_endian(value, length):
    return value.to_bytes(length, 'little')

# Dummy TxIn and TxOut objects
prev_tx = b'\x00' * 32  # 32 byte dummy previous transaction hash
prev_index = 0  # Index of the previous transaction output
sequence = 0xffffffff  # Sequence number

# Create a TxIn object
tx_in = TxIn(prev_tx, prev_index, Script(), sequence)

amount = 1000  # Amount in satoshi for TxOut
script_pubkey = Script()  # Dummy script for TxOut

# Create a TxOut object
tx_out = TxOut(amount, script_pubkey)

# Transaction version and locktime
version = 1
locktime = 0

# Create the Tx object
tx = Tx(version, [tx_in], [tx_out], locktime)

# Print the Tx object
print(tx)
