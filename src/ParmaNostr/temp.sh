function make_nostr_key_files2 {
debug "in make nostr key files 2 - check files"
#For use when a valid mnemonic alrady exists
python3 <<END
import sys, copy, os
sys.path.append("$pn/src/ParmaWallet")
from classes import *
from functions import *
from functions2 import *
from variables import *
from nostr import *
import unicodedata, hashlib, binascii, hmac
sys.exit(3)
END
}