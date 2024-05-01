import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac

########################################################################################

def word_look_up(value):
    return seedlist[value].strip()

file_path = './english.txt'
file_store = '/home/parman/Desktop/file_store.txt'
known_string = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon" 
known_string_bin_string = 21 * "00000000000"
known_string_int = int(known_string_bin_string)

with open (file_path, 'r') as file:
    seedlist = file.readlines()

def dosearch(i0: int=0, i1: int=2048, j0: int=0, j1: int=2048):
    with open(file_store , "w") as file:  # truncates any existing file and starts over

        for i in range(i0, i1):
            for j in range (j0, j1):
                for k in range (0, 8): 
                    test_string = known_string_bin_string + bin(i)[2:].zfill(11) + bin(j)[2:].zfill(11) + bin(k)[2:].zfill(3)
                    test_string_int = int(test_string, 2)
                    test_string_bytes = test_string_int.to_bytes(32, 'big')
                    hashbyte = hash256(test_string_bytes)[:1]
        #            print("hashbyte", hashbyte)
                    hashval_int = int.from_bytes(hashbyte, 'big')
        #            print("hashval_int", hashval_int)
                    hashval_string = bin(hashval_int)[2:].zfill(8)
        #            print ("hashval_string", hashval_string)
        #            print ('ijk' , i , j, k)
                    final_word_val = k * 256 + hashval_int
        #            print( 'last 3 indexes' , i , j, final_word_val)

                    mnemonic_end_string = word_look_up(i) + ' ' + word_look_up(j) + ' ' + word_look_up(final_word_val)
    #                print(mnemonic_end_string)
                    complete_string = known_string + ' ' + mnemonic_end_string
                    test_keypair=get_all_child_keys('f', mnemonic=complete_string)
        #            print(len(test_keypair.public_key), type(test_keypair.public_key))
                    address=pubkey_to_bech32_custom(test_keypair.public_key)
                    print(address)
                    file.write(address + "\n")  # Convert result to string and append a newline
                    if address == 'bc1qfmqe4296g04eaczsns22exhqhmlvdx57xzx8tw':
                        print("words found, i j k:" , mnemonic_end_string)
                        input("<enter> to stop program")
                        exit()
    
########################################################################################

########################################################################################