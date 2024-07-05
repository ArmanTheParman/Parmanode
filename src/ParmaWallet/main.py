import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from nostr import *

the_mnemonic="leader monkey parrot ring guide accident before fence cannon height naive bean"
print(the_mnemonic, type(the_mnemonic))
the_keypair=derive_keys(depth="address", purpose=44, coin=1237, mnemonic=the_mnemonic) #NIP6
the_secret_bytes=the_keypair.private_key.secret_bytes
print(the_secret_bytes)
pubkey_schnorr=the_keypair.public_key[1:].hex()
print("pub", pubkey_schnorr)
#NSEC=make_nsec(the_secret_bytes)
#print(NSEC)
the_event=Event(pubkey=pubkey_schnorr, sec=the_secret_bytes, created_at=1718421481, kind=1, content="Why not just make every Tweet a Nostr event JSON?")

print(the_event)


x=nsec_to_bytes("nsec10allq0gjx7fddtzef0ax00mdps9t2kmtrldkyjfs8l5xruwvh2dq0lhhkp")
print(x)