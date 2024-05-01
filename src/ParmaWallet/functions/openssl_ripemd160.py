import ctypes
import ctypes.util

# Load the OpenSSL library
libcrypto = ctypes.CDLL(ctypes.util.find_library('crypto'))

# Set up the RIPEMD-160 functions
libcrypto.RIPEMD160_Init.argtypes = [ctypes.c_void_p]
libcrypto.RIPEMD160_Update.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t]
libcrypto.RIPEMD160_Final.argtypes = [ctypes.c_void_p, ctypes.c_void_p]

class RIPEMD160_CTX(ctypes.Structure):
    _fields_ = [("data", ctypes.c_ubyte * 144)]  # Size may need adjustment

def hash_ripemd160(data):
    ctx = RIPEMD160_CTX()
    result = (ctypes.c_ubyte * 20)()  # RIPEMD-160 produces a 160-bit hash (20 bytes)
    
    libcrypto.RIPEMD160_Init(ctypes.byref(ctx))
    libcrypto.RIPEMD160_Update(ctypes.byref(ctx), data, len(data))
    libcrypto.RIPEMD160_Final(ctypes.byref(result), ctypes.byref(ctx))
    
    return ''.join(format(x, '02x') for x in result)

# Example usage
data = b"Hello, world!"
hashed_data = hash_ripemd160(data)
print("RIPEMD-160 Hash:", hashed_data)