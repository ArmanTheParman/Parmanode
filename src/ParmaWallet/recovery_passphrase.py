from classes import *
from functions import *
from variables import *
import unicodedata, hashlib, binascii, hmac
from classes import *
from functions import *
from variables import * 

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

known_string = "000000000001111111111100000000000" #placeholder

# for i in range(0, 2048):
#     for j in range (0, 2048):
#         for k in range (0, 8): 
#             test_string = known_string + bin(i)[2:].zfill(11) + bin(j)[2:].zfill(11) + bin(k)[2:].zfill(7)
#             test_string = int(test_string, 2)
#             test_string = test_string.to_bytes(32, 'big')
#             hash256(test_string)[:1]
i = '0011'
j = '1111'
k = '0101'      
test_string = known_string + bin(i)[2:].zfill(11) + bin(j)[2:].zfill(11) + bin(k)[2:].zfill(7)
test_string = int(test_string, 2)
    # test_string = test_string.to_bytes(32, 'big')
    # hash256(test_string)[:1]       
       
       
       
        