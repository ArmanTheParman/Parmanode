import os
from classes import *
from functions import *
from functions2 import *
from variables import *
import unicodedata, hashlib, binascii, hmac

########################################################################################



known_words = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon" 
known_words_bin_string = 21 * "00000000000"
#known_words_int = int(known_words_bin_string)


def dosearch(file_store: str, i0: int=0, i1: int=2048, j0: int=0, j1: int=2048):

    def word_look_up(value):
        return seedlist[value].strip()

    wordlist_path = "/home/parman/parman_programs/parmanode/src/ParmaWallet/docs/english.txt"
    with open (wordlist_path, 'r') as file:
        seedlist = file.readlines()


        for i in range(i0, i1):
            with open(file_store , "a") as file:  # appends
                for j in range (j0, j1):
                    for k in range (0, 8): 
                        test = known_words_bin_string + bin(i)[2:].zfill(11) + bin(j)[2:].zfill(11) + bin(k)[2:].zfill(3)
                        test_int= int(test, 2)
                        test_bytes = test_int.to_bytes(32, 'big')
                        hashbyte = hash256(test_bytes)[:1]
            #            print("hashbyte", hashbyte)
                        hashval_int = int.from_bytes(hashbyte, 'big')
            #            print("hashval_int", hashval_int)
            #            hashval_string = bin(hashval_int)[2:].zfill(8)
            #            print ("hashval_string", hashval_string)
            #            print ('ijk' , i , j, k)
                        final_word_val = k * 256 + hashval_int
            #            print( 'last 3 indexes' , i , j, final_word_val)

                        mnemonic_end_string = word_look_up(i) + ' ' + word_look_up(j) + ' ' + word_look_up(final_word_val)
        #                print(mnemonic_end_string)
                        complete_string = known_words + ' ' + mnemonic_end_string
                        test_keypair=derive_keys('f', mnemonic=complete_string)
            #            print(len(test_keypair.public_key), type(test_keypair.public_key))
                        address=pubkey_to_bech32_custom(test_keypair.public_key)
                        print(address)
                        file.write(address + "\n")  # Convert result to string and append a newline
                        if address == 'bc1qfmqe4296g04eaczsns22exhqhmlvdx57xzx8tw':
                            print("words found, i j k:" , mnemonic_end_string)
                            with open ("/home/parman/Desktop/SUCCESS.TXT", 'w') as file:
                                file.write("SUCCESS")
                            return 0
        
    ########################################################################################

    ########################################################################################