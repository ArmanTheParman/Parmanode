from classes.FieldElement import *
from functions.old_functions import *
from functions.PW_Base58 import *
#from point import *
#from S256 import *
#import hashlib
from random import randint
import hmac

class PrivateKey:
    
    def __init__(self, secret):
        self.secret=int(secret)
        self.point=secret*G #the pubkey

    def hex(self):
            return '{:x}'.format(self.secret).zfill(64)

    def sign(self, z):
        k = randint(0,N)   #NEED TO CHANGE THIS
        r = (k*G).x.num
        k_inv = pow(k, N-2, N)
        s = (z + r*self.secret)*k_inv % N
        if s > N/2:
            s= N - s
        return Signature(r, s)

    def deterministic_k(self, z):
        k = b'\x00' * 32
        v = b'\x01' * 32
        if z > N:
            z -= N
        z_bytes = z.to_bytes(32, 'big')
        secret_bytes = self.secret.to_bytes(32, 'big')
        s256 = hashlib.sha256
        k = hmac.new(k, v + b'\x00' + secret_bytes + z_bytes, s256).digest()
        v = hmac.new(k, v, s256).digest() 
        k = hmac.new(k, v + b'\x01' + secret_bytes + z_bytes, s256).digest()
        v = hmac.new(k, v, s256).digest() 

        while True:
            v = hmac.new(k, v, s256).digest() 
            candidate = int.from_bytes(v, 'big')
            if candidate >=1 and candidate < N:
                return candidate
            k = hmac.new(k, v + b'\x00', s256).digest()
            v = hmac.new(k, v, s256).digest()
    def wif(self, compressed="compressed", testnet=False):
        secret_bytes = self.secret.to_bytes(32, 'big')
        if testnet:
            prefix = b'\xef'
        else:
            prefix = b'\x80'
        if compressed=="compressed":
            suffix = b'\x01'
        else:
            suffix = b''
        return base58check_encode(prefix + secret_bytes + suffix)
            
        