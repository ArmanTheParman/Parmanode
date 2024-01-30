import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from classes import PrivateKey
from variables import * 
from classes import N
import base58
from ecdsa import SECP256k1
from typing import Union


class BIP32_master_node:

    def __init__(self, mnemonic: str, passphrase): #Depth=0, Derivation path is m (not m/0), so "index" meaningless at this level.
    #def __init__(self, mnemonic: str, passphrase: str): #Depth=0, Derivation path is m (not m/0), so "index" meaningless at this level.
        # print("\nBIP32_master_node function called. Default arguments are mnemonic=None, passphrase="", byteseed=None\n")

        # if mnemonic == "choose":
        #     self.mnemonic = input("Enter a mnemonic seed, 12 words, seperated by a space: \n: ")
        #     self.passphrase = input("Enter a passphrase, <enter> for none \n: ")
        #     print("Warning: The mnemonic seed has not been checked for BIP39 compliance (eg valid words or checksum)\n")
        # elif mnemonic == "abandon":
        #     print("mnemonic=None, so smallest BIP39 seed in use. Warning, it is not secure.")
        #     print("To use a custom mnemonic, enter 'choose' as an argument\n")
        #     self.mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"  
        #     self.passphrase = ""
        # elif mnemonic is None:
        #     raise TypeError("No Mnemonic set")
        # else: 
        #     self.mnemonic = mnemonic
        #     self.passphrase = passphrase

        self.mnemonic = mnemonic
        self.passphrase = passphrase

        # if not byteseed is None:
        #     if not mnemonic is None:
        #         print("Warning, mnemonic provided will be discarded as byteseed provided.")
        #     if not isinstance (byteseed, bytes):
        #         raise TypeError("byteseed should be bytes object")
        #     if len(byteseed) not in (16, 32, 64): 
        #         ValueError("Byte needs to be length 16, 32, or 64") 
        #     self.byte_seed = byteseed 
        
    #if byteseed is None: 
#        self.mnemonic = unicodedata.normalize("NFKD", self.mnemonic)
#        self.passphrase = unicodedata.normalize("NFKD", self.passphrase)

        #Add "mnemonic" string. If passphrase empty, then it's just "mnemonic"
        #self.passphrase = "mnemonic" + self.passphrase 
        self.passphrase = b'mnemonic' + self.passphrase 

        #encode the mnemonic_ssed and passphrase (byte object)
        self.mnemonic = self.mnemonic.encode("utf-8")
        # self.passphrase = self.passphrase.encode("utf=8")

        #make a BIP39 seed (512 bits, 64 hex characters, byte object)
        self.byte_seed = hashlib.pbkdf2_hmac("sha512", self.mnemonic, self.passphrase, 2048)  
        self.hex_seed = binascii.hexlify(self.byte_seed[:64])
        self.hexstring_seed = binascii.hexlify(self.byte_seed[:64]).decode()
        
            #BIP39 spits out a 512 bit seed (because of sha512), to use in BIP32
       
        
        #Make the priv and pub keys

        #make I
        self.I = hmac.new(b"Bitcoin seed", self.byte_seed, hashlib.sha512).digest() #key=b"Bitcoin seed" data=seed
        #left and right parts
        Il, Ir = self.I[:32], self.I[32:] #Il=master secret key, Ir=master chain code. [ 32 byte object ]
        # x=binascii.hexlify(Ir)
        Il_int=int.from_bytes(Il, 'big')
        if Il_int == 0 or Il_int > N:
            raise ValueError("Key is invalid. It is not possible to make a key with this seed. \n" +\
                            "This is actually incredible, keep this seed; 1 in 2 ^127 chance of finding it.") 
        
        self.private_key = PrivateKey(Il_int)
        self.chain_code = Ir
        self.public_key_full = (self.private_key.point)
        self.public_key = (self.private_key.point.sec())
        self.private_key_33b = b'\0' + Il

    def serialize(self):
        #Extended Key Serialisation (no checksum yet)
        # 1 byte, version prefix; 1 byte for depth; 4 bytes for parent PUB KEY (always pub) fingerprint; 
        # then 32 bytes for chaincode (yes it's on the "left"); 33 bytes for compressed pubkey, or if private
        # key, then 1 zero byte and then 32 bytes private key. = TOTAL 78 bytes

        self.depth = depth #from variables, but probably unecessary, it's just a zero byte
        raw_xprv = xprv_prefix + self.depth + fp + child + self.chain_code + self.private_key_33b
        raw_xpub = xpub_prefix + self.depth + fp + child + self.chain_code + self.public_key

        # Add checksum...
        # Double hash the raw key, and add the last 4 bytes of the result the raw key.
        hashed_xprv = hashlib.sha256(raw_xprv).digest()
        hashed_xprv = hashlib.sha256(hashed_xprv).digest()

        hashed_xpub = hashlib.sha256(raw_xpub).digest()
        hashed_xpub = hashlib.sha256(hashed_xpub).digest() 

        # Adding checksum to the end
        raw_xprv += hashed_xprv[:4]
        raw_xpub += hashed_xpub[:4]

        # Convert bytes to base58 text
        self.xprv=PW_Base58.encode_base58(raw_xprv)
        self.xpub=PW_Base58.encode_base58(raw_xpub)
        # self.xprv=base58.b58encode(raw_xprv)
        # self.xpub=base58.b58encode(raw_xpub)
        
        print("xprv is: " , self.xprv)
        print("xpub is: " , self.xpub)

    def __repr__(self):
        return "Need to serialize to get output in Hex" 

class child_key:
    def __init__(self, parent: Union[BIP32_master_node, 'child_key'], depth=1, account=0, hardened=True, serialize=False, PK=False, address=False ): #account is also the "index"
    
        if hardened:
            i = 2 ** 31 + account
        else:
            i = account

        while True:
            if hardened:
                I2 = hmac.new(parent.chain_code, parent.private_key_33b + int.to_bytes(i , 4, 'big'), hashlib.sha512).digest()  # (key, data, hash alogrithm)
            else:
                I2 = hmac.new(parent.chain_code, parent.public_key + int.to_bytes(i , 4, 'big'), hashlib.sha512).digest()  # (key, data, hash alogrithm)

            Il2, self.chain_code = I2[:32], I2[32:]

            if PK == False:
                child_private_key = (int.from_bytes(Il2, 'big') + int.from_bytes(parent.private_key_33b[1:], 'big')) % N  #arithmatic, not concatenation.
                self.private_key = PrivateKey(child_private_key)
                self.private_key_33b = b'\0' + self.private_key.secret_bytes
                self.public_key = self.private_key.point.sec()

                if int.from_bytes(Il2, 'big') > N or self.private_key.secret == 0 :
                    print("Rare key, incrementing")
                    i += 1 
                else:
                    break

            else: #For Watching Wallets
                        self.public_key = Il2 + parent.public_key # This is point addition, not concatenation
                        break

        if serialize == True:
            self.parent_public_key = parent.public_key 
            self.depth = depth
            self.i = i
       
    def serialize (self):
        
        depth_child = int.to_bytes(self.depth, 1, 'big')
        index_child = int.to_bytes(self.i, 4, 'big')
        fp_from_parent = hash160(self.parent_public_key)[:4]
        
        raw_xprv = xprv_prefix + depth_child + fp_from_parent + index_child + self.chain_code + self.private_key_33b
        raw_xpub = xpub_prefix + depth_child + fp_from_parent + index_child + self.chain_code + self.public_key

        hashed_xprv = hashlib.sha256(raw_xprv).digest()
        hashed_xprv = hashlib.sha256(hashed_xprv).digest()

        hashed_xpub = hashlib.sha256(raw_xpub).digest()
        hashed_xpub = hashlib.sha256(hashed_xpub).digest() 

        # Adding checksum to the end
        raw_xprv += hashed_xprv[:4]
        raw_xpub += hashed_xpub[:4]

        # Convert bytes to base58 text
        self.xprv=PW_Base58.encode_base58(raw_xprv)
        self.xpub=PW_Base58.encode_base58(raw_xpub)

#       print(self.public_key)
