from classes import *
from functions import *
from functions2 import *
from variables import *


seed_words = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
passphrase = ""
wordlist_path = "/home/parman/parman_programs/parmanode/src/ParmaWallet/docs/english.txt"
with open (wordlist_path, 'r') as file:
    bip39wordlist = file.readlines()
                        
keypair=derive_keys(depth='address', mnemonic=seed_words, passphrase=passphrase, purpose=84, coin=0, account=0, change=0, address=0)
bip84address=pubkey_to_bech32_custom(keypair.public_key)
print(bip84address)