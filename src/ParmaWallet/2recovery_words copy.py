import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac

########################################################################################

file_path = './english.txt'
file_store = '/home/parman/Desktop/file_store.txt'
with open (file_path, 'r') as file:
    seedlist = file.readlines()

def word_look_up(value):
    return seedlist[value].strip()

known_string = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon" 

known_string_bin_string = 21 * "00000000000"
known_string_int = int(known_string_bin_string)
valid_combinations = []

with open(file_store , "a") as file:  # Open in append mode to add to the file

    for i in range(0, 1):
        for j in range (0, 2048):
            for k in range (0, 2048): 
                mnemonic_end_string = word_look_up(i) + ' ' + word_look_up(j) + ' ' + word_look_up(k)
                print(mnemonic_end_string)
                complete_string = known_string + ' ' + mnemonic_end_string
                test_keypair=get_all_child_keys('f', mnemonic=complete_string)
    #            print(len(test_keypair.public_key), type(test_keypair.public_key))
                address=pubkey_to_bech32_custom(test_keypair.public_key)
                file.write(address + "\n")  # Convert result to string and append a newline
 
########################################################################################

########################################################################################
