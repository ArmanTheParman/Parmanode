from classes import *
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 

""
aa = BIP32_master_node_binary(byte_seed="0100001010010010101011100101110101111001010100101100101110000110101101011000001000100000000000110010100011011010001011001111010010111010011101111000100111111110010101110000010111001010000010001101001001100101011111011011001001101110000000001011011100101111")
print("back in recover.py")
aa.serialize()
exit



#charlist = ( b'a', b'b', b'c', b'c', b'd', b'e', b'f', b'g', b'h', b'i', b'j', b'k', b'l', b'm', b'n', b'o', b'p', b'q', b'r', b's', b't', b'u', b'v', b'w', b'x', b'y', b'z')
# mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
# for ii in charlist:
#     for jj in charlist:
#         for kk in charlist:
#             if ii == jj and jj == kk:
#                 continue
#             for ll in charlist:
#                 for mm in charlist:
#                     for nn in charlist:
#                         for oo in charlist:
#                             passphrase = b'garry' + ii + jj + kk + ll + mm + nn + oo
#                             print(passphrase)
#                             a = BIP32_master_node(mnemonic, passphrase)
#                             b = child_key(a, depth=1, account=49, hardened=True, serialize=False) #purpose
#                             c = child_key(b, depth=1, account=0, hardened=True, serialize=False) #coin
#                             d = child_key(c, depth=1, account=0, hardened=True, serialize=False) #account
#                             e = child_key(d, depth=1, account=0, hardened=False, serialize=False) #int/ext
#                             f = child_key(e, depth=1, account=0, hardened=False, serialize=False) #address
# xxx=BIP32_master_node()
