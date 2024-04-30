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

########################################################################################
########################################################################################
########################################################################################

target_string = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon art"
#target_string_int = int(target_string)

known_string = 21 * "00000000000"
known_string_int = int(known_string)
valid_combinations = []

for i in range(0, 2048):
    for j in range (0, 2048):
        for k in range (0, 8): 
            test_string = known_string + bin(i)[2:].zfill(11) + bin(j)[2:].zfill(11) + bin(k)[2:].zfill(7)
            test_string_int = int(test_string, 2)
            test_string_bytes = test_string_int.to_bytes(32, 'big')
            hashbyte = hash256(test_string_bytes)[:1]
            print("hashbyte", hashbyte)
            hashval_int = int.from_bytes(hashbyte, 'big')
            print("hashval_int", hashval_int)
            hashval_string = bin(hashval_int)[2:].zfill(8)
            print ("hashval_string", hashval_string)
            print ('ijk' , i , j, k)
            input (<enter>)

########################################################################################
########################################################################################
########################################################################################
# i = '00000000000'
# i = int(i)
# j = '00000000000'
# j = int(j)
# k = '0000000'      
# k = int(k)
# test_string = known_string + bin(i)[2:].zfill(11) + bin(j)[2:].zfill(11) + bin(k)[2:].zfill(7)
# test_string_int = int(test_string, 2)
# test_string_bytes = test_string_int.to_bytes(32, 'big')
# hashbyte = hash256(test_string_bytes)[:1]
# print("hashbyte", hashbyte)
# hashval_int = int.from_bytes(hashbyte, 'big')
# print("hashval_int", hashval_int)
# hashval_string = bin(hashval_int)[2:].zfill(8)
# print ("hashval_string", hashval_string)

# real_string_prefix_string = test_string + "00000000"
# print("rsps", real_string_prefix_string)
# real_string_prefix_int = int(real_string_prefix_string)
# print("rspi", real_string_prefix_int)
# real_string_total_tocheck = real_string_prefix_int + hashval_int
# print("rsttc", real_string_total_tocheck)
# real_string_total = bin(real_string_total_tocheck)[2:].zfill(264)
# print("rst", real_string_total)



       
       
       
        