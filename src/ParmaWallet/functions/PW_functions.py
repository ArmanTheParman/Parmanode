import hashlib
import functions.PW_Base58 import *


#usage - pass a byte object, encode the string to do so
#eg "hello".encode('utf-8')

def hash160(so):
    #sha256 followed by ripemd160
    s=b's'
    return hashlib.new('ripemd160', hashlib.sha256(so).digest()).digest()
