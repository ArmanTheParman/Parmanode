import unicodedata, hashlib, binascii, hmac
from classes import *
from classes import PrivateKey
from variables import * 
from classes import S256

class BIP39seed:
    def __init__(self): 
        mnemonic = input("Enter a mnemonic seed, 12 words, seperated by a space: \n: ")
        if mnemonic == "":
            mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about" 
        
        passphrase = input("Enter a passphrase, <enter> for none \n: ")
        mnemonic = unicodedata.normalize("NFKD", mnemonic)
        passphrase = unicodedata.normalize("NFKD", passphrase)

        #Add "mnemonic" string. If passphrase empty, then it's just "mnemonic"
        passphrase = "mnemonic" + passphrase 

        #encode the mnemonic_ssed and passphrase (byte object)
        self.mnemonic = mnemonic.encode("utf-8")
        self.passphrase = passphrase.encode("utf=8")

        #make a BIP39 seed (512 bits, 64 hex characters, byte object)
        self.byte_seed = hashlib.pbkdf2_hmac("sha512", self.mnemonic, self.passphrase, 2048)  
        self.hex_seed = binascii.hexlify(self.byte_seed[:64])
        self.hexstring_seed = binascii.hexlify(self.byte_seed[:64]).decode()

        #Now make the priv and pub keys (BIP32 starts here)...
        #make I

        I = hmac.new(b"Bitcoin seed", self.byte_seed, hashlib.sha512).digest() #key=b"Bitcoin seed" data=seed
        #left and right parts
        Il, Ir = I[:32], I[32:] #Il=master secret key, Ir=master chain code. [ 32 byte object ]
        # x=binascii.hexlify(Ir)
        Il_int=int.from_bytes(Il, 'big')
        print(Il_int)
        if Il_int == 0 or Il_int > N:
            raise ValueError("Key is invalid. It is not possible to make a key with this seed. \n" +\
                            "This is actually incredible, keep this seed; 1 in 2 ^127 chance of finding it.") 
        
        self.master_private_key = PrivateKey(int.from_bytes(Il, 'big'))
        self.master_chain_code = Ir
        self.master_public_key = ((self.master_private_key.point).sec())
        self.master_priv_key_33b = b'\0' + Il
                            
        #Extended Key Serialisation (no checksum yet)
        # 1 byte, version prefix; 4 bytes for depth; 4 bytes for parent PUB KEY (always pub) fingerprint; 
        # then 32 bytes for chaincode (yes it's on the "left"); 33 bytes for compressed pubkey, or if private
        # key, then 1 zero byte and then 32 bytes private key. = TOTAL 78 bytes

        raw_xprv = xprv_prefix + depth + fp + child + self.master_chain_code + self.master_priv_key_33b
        raw_xpub = xpub_prefix + depth + fp + child + self.master_chain_code + self.master_public_key
        
        print("raw xprv is: "  , encode_base58(raw_xprv))
        print("raw xpub is : " , encode_base58(raw_xpub))

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
        self.xprv=base58.b58encode(raw_xprv)
        self.xpub=base58.b58encode(raw_xpub)

        print("xprv is: ", self.xprv)
        print("xpub is: ", self.xpub)
            
    def __repr__(self):
        return "BIP39seed object" + \
        "\nThe bin_seed in hex string: {}".format() + \
        "\nThe bin_seed: {}".format(self.byte_seed) + \
        "\nThe bin_seed in hex: {}".format(binascii.hexlify(self.byte_seed[:64])) + \
        "\nThe xprv is: {}".format(self.xprv) +\
        "\nThe xpub is: {}".format(self.xpub)
           
