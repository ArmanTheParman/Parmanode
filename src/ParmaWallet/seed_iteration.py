import os
from functions import *

file_path = './english.txt'

with open (file_path, 'r') as file:
    seedlist = file.readlines()

print(seedlist[0]) # abandon
print(seedlist[2047]) #zoo

index = 5
print(bin(index)[2:].zfill(11)) #convert to binary, remove prefix, THEN fill to 11 digits (string object)
x = (bin(index)[2:].zfill(11)) 
y = int(x)


def seed_checksum(decimal_array):
    #partial seed is a string
    print(decimal_array) 




########################################################################################
da = []
da.append(0)
da.append(2047)

decimal_array = [1,2,3,4]
binary_array = [b'00000000001', b'002']

print( b'01' + b'01')

def binary_string_to_int(binary):
    int(binary)

print("xxxx")

b1=int('111000',2)
for i in range(7):
    b1+=1
    print(bin(b1)[2:])
    hash256(int.to_bytes(10))