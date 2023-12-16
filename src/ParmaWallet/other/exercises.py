from functions.PW_signing import *
from functions.PW_Base58 import *
from classes.privatekey import *
from classes.S256 import *
#sign1()
#x=sign2()
#print(x)
#print(encode_base58_checksum(0x1fff111.to_bytes(16, 'big')))

#Exercise 2
# mypubkey=PrivateKey(0x54321deadbeef).point
# print(mypubkey.sec().hex())
# correct

#Exercise 5a - uncompressed SEC on testnet
# mypubkey=PrivateKey(5002).point
# print(mypubkey.address("uncompressed", testnet=True))
#correct

#Exercise 5b - 2020**5 compressed SEC on testnet
# print(PrivateKey(2020**5).point.address("compressed", testnet=True))
#correct

#Exercise 5c - 0x12345deadbeef compressed mainnet
# print(PrivateKey(0x12345deadbeef).point.address("compressed"))
#correct

#Exercis 6a - wif for private key, 5003 secret, compressed, testnet
# print(PrivateKey(0x54321deadbeef).wif(testnet=False))
#correct

#testing child public key
cpk=0x049c9276e17c68cee5c190ee888d1848d24f0d6bc62492b257b59db01a7937442058e31e8b087c22368de895888e7c0e6975ab7396a66f8b6bd5a4eaf8d278eafb

cpk_point=S256Point.parse(cpk.to_bytes(65, 'big'))
print(cpk_point.address("compressed"))
