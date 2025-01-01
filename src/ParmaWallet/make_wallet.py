from classes import *
from functions import *
from functions2 import *
from variables import *


seed_words = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
passphrase = ""
depth="address"
purpose=44
account=0
change=0
address=0
# wordlist_path = "/home/parman/parman_programs/parmanode/src/ParmaWallet/docs/english.txt"
# with open (wordlist_path, 'r') as file:
#     bip39wordlist = file.readlines()
                        
keypair=derive_keys(depth='address', mnemonic=seed_words, passphrase=passphrase, purpose=purpose, coin=0, account=account, change=change, address=address)
bip84address=pubkey_to_bech32_custom(keypair.public_key)
legacyaddress=public_to_address(public_key=keypair.public_key)
if purpose == 84:
    print(bip84address)
if purpose == 44:
    print(legacyaddress)