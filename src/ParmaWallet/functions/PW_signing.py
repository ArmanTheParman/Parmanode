from ParmaWallet.classes.FieldElement import *
from ParmaWallet.functions.PW_functions import *
from ParmaWallet.classes.point import *
from ParmaWallet.classes.S256 import *
import hashlib

def sign1():
    e = int(myhash(b'secret'),16)
    z = int(myhash(b'message'),16)
    k = 123456789
    r = (k*G).x.num
    k_inv = pow(k, N-2, N)
    s = (z+r*e) * k_inv %N
    point = e*G
    print (point)

def sign2():
    e=12345
    z=int.from_bytes(myhash(b'Programming Bitcoin!', "256", "byte"), 'big')
    k=93482229839208374
    r=(k*G).x.num
    return int((z+e*(r))/k % N)
