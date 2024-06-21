import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from parmanostr import *

test_mnemonic="mother antique cheap vanish lift excuse execute horse pause vacuum own slam"
test_keypair=derive_keys(depth="address", purpose=44, coin=1237, mnemonic=test_mnemonic) #NIP6
test_secret_bytes=test_keypair.private_key.secret_bytes
test_event=Event(pubkey="fad6540c8f2fd2a16a25d0d82dd95d3bad7890d435d1690848a0a77d2883a447", sec=test_secret_bytes, created_at=1718421481, kind=1, content="\"Tax is ok, I'm happy to pay tax\".\n\n=\n\n\"I think people getting raped is ok, I like sex\".")

print(test_event)