from ParmaWallet.classes import S256, FieldElement, point
from ParmaWallet.functions import PW_functions
import hashlib
import hmac

key = b"my_key"
message = b"Hello, HMAC!"

h = hmac.new(key, message, digestmod="SHA256")

print(h.hexdigest())

print(0x80)
     
x=b'hi'
y=int.from_bytes(x, 'big')
print(y)