import sys, copy
from ParmaWallet.classes.FieldElement import *
from ParmaWallet.classes.point import * 
from ParmaWallet.functions.old_functions import *
from ParmaWallet.classes.S256 import * 
from ParmaWallet.functions.PW_signing import *
from ParmaWallet.classes.privatekey import *


Px=0x887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c
Py=0x61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34

z1=0xec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60
r1=0xac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395
s1=0x68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4

# point=S256Point(Px,Py)
# s_inv=pow(s1, N-2, N)
# u = z1 * s_inv % N
# v = r1 * s_inv % N
# print((u*G + v*point).x.num == r1)

# print(sign2())

parman=PrivateKey(0xdeadbe22ef5421)
aa=parman.point.sec("compressed", "bytes")
print(aa.hex())
# XXX=S256Point.parse(aa)
# print(aa)
message=int((hashlib.sha256(b'hi').hexdigest()),16)
psign=parman.sign(message)
psign.der()
print(psign.der("hex"))

#parman.sign()
