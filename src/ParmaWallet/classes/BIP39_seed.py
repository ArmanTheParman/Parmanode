import unicodedata, hashlib, binascii, hmac

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

        I = hmac.new(b"Bitcoin seed", self.byte_seed, hashlib.sha512).digest()
        #left and right parts
        Il, Ir = I[:32], I[32:]

        # unfinished

    def __repr__(self):
        return "BIP39seed object" + \
        "\nThe bin_seed in hex string: {}".format() + \
        "\nThe bin_seed: {}".format(self.byte_seed) + \
        "\nThe bin_seed in hex: {}".format(binascii.hexlify(self.byte_seed[:64]))

