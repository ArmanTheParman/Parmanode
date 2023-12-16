import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from classes import PrivateKey
from variables import * 
from classes import N
import base58
from ecdsa import SECP256k1

class BIP39seed:
    def __init__(self): 
        # mnemonic = input("Enter a mnemonic seed, 12 words, seperated by a space: \n: ")
        # if mnemonic == "":
        #     mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about" 
        
        # passphrase = input("Enter a passphrase, <enter> for none \n: ")
        # mnemonic = unicodedata.normalize("NFKD", mnemonic)
        # passphrase = unicodedata.normalize("NFKD", passphrase)

        # #Add "mnemonic" string. If passphrase empty, then it's just "mnemonic"
        # passphrase = "mnemonic" + passphrase 

        # #encode the mnemonic_ssed and passphrase (byte object)
        # self.mnemonic = mnemonic.encode("utf-8")
        # self.passphrase = passphrase.encode("utf=8")

        # #make a BIP39 seed (512 bits, 64 hex characters, byte object)
        # self.byte_seed = hashlib.pbkdf2_hmac("sha512", self.mnemonic, self.passphrase, 2048)  
        # self.hex_seed = binascii.hexlify(self.byte_seed[:64])
        # self.hexstring_seed = binascii.hexlify(self.byte_seed[:64]).decode()
       
        #override self.byte_seed for testing... 
        self.byte_seed = int.to_bytes(0x000102030405060708090a0b0c0d0e0f, 16, 'big')
        self.byte_seed2 = int.to_bytes(0xfffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542, 64, 'big')
        self.byte_seed3 = int.to_bytes(0x4b381541583be4423346c643850da4b320e46a87ae3d2a4e6da11eba819cd4acba45d239319ac14f863b8d5ab5a0d0c64d2e8a1e7d1457df2e5a3c51c73235be, 64, 'big')

        # CRUCIAL THAT THE CORRECT BYTE SIZE IS USED TO TAKE THE INTEGER.
        # From BIP32: Generate a seed byte sequence S of a chosen length (between 128 and 512 bits; 256 bits is advised) from a (P)RNG.

        self.byte_seed4 = int.to_bytes(0x3ddd5602285899a946114506157c7997e5444528f3003f6134712147db19b678, 32, 'big')
       
        
        #Now make the priv and pub keys (BIP32 starts here)...
        #make I

        self.I = hmac.new(b"Bitcoin seed", self.byte_seed, hashlib.sha512).digest() #key=b"Bitcoin seed" data=seed
        #left and right parts
        Il, Ir = self.I[:32], self.I[32:] #Il=master secret key, Ir=master chain code. [ 32 byte object ]
        # x=binascii.hexlify(Ir)
        Il_int=int.from_bytes(Il, 'big')
        if Il_int == 0 or Il_int > N:
            raise ValueError("Key is invalid. It is not possible to make a key with this seed. \n" +\
                            "This is actually incredible, keep this seed; 1 in 2 ^127 chance of finding it.") 
        
        self.master_private_key = PrivateKey(Il_int)
        self.master_chain_code = Ir
        self.master_public_key_full = (self.master_private_key.point)
        self.master_public_key = (self.master_private_key.point.sec())
        self.master_priv_key_33b = b'\0' + Il


        #Extended Key Serialisation (no checksum yet)
        # 1 byte, version prefix; 4 bytes for depth; 4 bytes for parent PUB KEY (always pub) fingerprint; 
        # then 32 bytes for chaincode (yes it's on the "left"); 33 bytes for compressed pubkey, or if private
        # key, then 1 zero byte and then 32 bytes private key. = TOTAL 78 bytes

        self.depth = depth #from variables, but probably unecessary, it's just 4 bytes of zero
        raw_xprv = xprv_prefix + self.depth + fp + child + self.master_chain_code + self.master_priv_key_33b
        raw_xpub = xpub_prefix + self.depth + fp + child + self.master_chain_code + self.master_public_key

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

        print("Master xprv is: ", self.xprv)
        print("Master xpub is: ", self.xpub)
            
    def __repr__(self):
        return "BIP39seed object" + \
        "\nThe bin_seed: {}".format(self.byte_seed) + \
        "\nThe bin_seed in hex: {}".format(binascii.hexlify(self.byte_seed[:64])) + \
        "\nThe xprv is: {}".format(self.xprv) +\
        "\nThe xpub is: {}".format(self.xpub)

    def make_child_private_key(self, account=0, hardened=True):
        #for hardened child
        if hardened:
            i = 2 ** 31 + account
        else:
            i = account
        while True:
            I2 = hmac.new(self.master_chain_code, self.master_priv_key_33b + int.to_bytes(i , 4, 'big'), hashlib.sha512).digest()  # (key, data, hash alogrithm)
            Il2, self.child_chain_code = I2[:32], I2[32:]
            child_private_key = (int.from_bytes(Il2, 'big') + int.from_bytes(self.master_priv_key_33b[1:], 'big')) % N  #arithmatic, not concatenation.
            self.child_private_key = PrivateKey(child_private_key)
            self.child_private_key_33b = b'\0' + self.child_private_key.secret_bytes
            self.child_public_key = self.child_private_key.point.sec()
            if int.from_bytes(Il2, 'big') > N or self.child_private_key.secret == 0 :
                print("Rare key, incrementing")
                i += 1 
            else:
                break
       
        #Serialisation 
        depth_child = int.to_bytes(int.from_bytes(self.depth , 'big') + 1, 1, 'big')
        print(depth_child)
        index_child = int.to_bytes(i, 4, 'big')

        fp_from_parent = hash160(self.master_public_key)[:4]
        print(fp_from_parent)
        raw_xprv = xprv_prefix + depth_child + fp_from_parent + index_child + self.child_chain_code + self.child_private_key_33b
        raw_xpub = xpub_prefix + depth_child + fp_from_parent + index_child + self.child_chain_code + self.child_public_key

        hashed_xprv = hashlib.sha256(raw_xprv).digest()
        hashed_xprv = hashlib.sha256(hashed_xprv).digest()

        hashed_xpub = hashlib.sha256(raw_xpub).digest()
        hashed_xpub = hashlib.sha256(hashed_xpub).digest() 

        # Adding checksum to the end
        raw_xprv += hashed_xprv[:4]
        raw_xpub += hashed_xpub[:4]

        # Convert bytes to base58 text
        self.child_xprv=PW_Base58.encode_base58(raw_xprv)
        self.child_xpub=PW_Base58.encode_base58(raw_xpub)

        print("Child xprv is: ", self.child_xprv)
        print("Child xpub is: ", self.child_xpub)
        
    
        